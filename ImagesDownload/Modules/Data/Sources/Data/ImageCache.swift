//
//  ImageCache.swift
//  Presentation
//
//  Created by Nguyễn Công Thư on 28/9/25.
//

import UIKit
import CryptoKit

public protocol ImageCacheProtocol {
    func image(for url: URL) -> UIImage?
    func save(_ image: UIImage, for url: URL)
}

public final class ImageCache: ImageCacheProtocol {
    private let memoryCache: NSCache<NSURL, UIImage>
    private let fileManager: FileManager
    private let diskCacheURL: URL
    private let ioQueue: DispatchQueue
    
    public init(
        memoryCache: NSCache<NSURL, UIImage> = NSCache<NSURL, UIImage>(),
        fileManager: FileManager = .default,
        cacheDir: URL? = nil,
        ioQueue: DispatchQueue = DispatchQueue(label: "ImageCache.IO", qos: .utility)
    ) {
        self.memoryCache = memoryCache
        self.fileManager = fileManager
        self.ioQueue = ioQueue
        
        let dir = cacheDir ?? fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        self.diskCacheURL = dir.appendingPathComponent("ImageCache")
        
        memoryCache.totalCostLimit = 30 * 1024 * 1024
        
        if !fileManager.fileExists(atPath: diskCacheURL.path) {
            try? fileManager.createDirectory(at: diskCacheURL, withIntermediateDirectories: true)
        }
    }
    
    public func image(for url: URL) -> UIImage? {
        if let image = memoryCache.object(forKey: url as NSURL) {
            return image
        }
        
        var loadedImage: UIImage?
        ioQueue.sync {
            let fileURL = diskCacheURL.appendingPathComponent(url.hashedFileName)
            if let data = try? Data(contentsOf: fileURL),
               let img = UIImage(data: data) {
                let cost = Int(img.size.width * img.size.height)
                memoryCache.setObject(img, forKey: url as NSURL, cost: cost)
                loadedImage = img
            }
        }
        return loadedImage
    }
    
    public func save(_ image: UIImage, for url: URL) {
//        Trên màn hình Retina 2× hoặc 3×:
//        100pt × 100pt thực chất là 200×200 hoặc 300×300 pixels.
//        Mỗi pixel thường dùng 4 byte (RGBA 8-bit).
//        Do đó cost thực sự ≈ width * scale * height * scale * 4.
        let pixels = Int(image.size.width * image.scale * image.size.height * image.scale)
        let cost = pixels * 4
        memoryCache.setObject(image, forKey: url as NSURL, cost: cost)
        
        ioQueue.async {
            let fileURL = self.diskCacheURL.appendingPathComponent(url.hashedFileName)
            if let data = image.jpegData(compressionQuality: 1.0) {
                try? data.write(to: fileURL)
            }
        }
    }
}

extension URL {
    var hashedFileName: String {
        let data = Data(self.absoluteString.utf8)
        let hash = SHA256.hash(data: data)
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}
