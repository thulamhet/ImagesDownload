//
//  ImageCache.swift
//  Presentation
//
//  Created by Nguyễn Công Thư on 28/9/25.
//

import UIKit

final class ImageCache {
    static let shared = ImageCache()
    
    private let memoryCache = NSCache<NSURL, UIImage>()
    private let fileManager = FileManager.default
    private let diskCacheURL: URL
    
    private init() {
        let cacheDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        diskCacheURL = cacheDir.appendingPathComponent("ImageCache")
        memoryCache.totalCostLimit = 30 * 1024 * 1024 // Giới hạn mem cache 30 mb
//      memoryCache.countLimit = 30 // Giới hạn số ảnh trong mem cache
        if !fileManager.fileExists(atPath: diskCacheURL.path) {
            try? fileManager.createDirectory(at: diskCacheURL, withIntermediateDirectories: true)
        }
    }
    
    // Lấy ảnh
    func image(for url: URL) -> UIImage? {
        // 1. Memory
        if let image = memoryCache.object(forKey: url as NSURL) {
            return image
        }
        
        // 2. Disk
        let fileURL = diskCacheURL.appendingPathComponent(url.hashedFileName)
        if let data = try? Data(contentsOf: fileURL), let image = UIImage(data: data) {
            memoryCache.setObject(image, forKey: url as NSURL) // promote lên RAM
            return image
        }
        return nil
    }
    
    // Lưu ảnh
    func save(_ image: UIImage, for url: URL) {
        // 1. Memory
        memoryCache.setObject(image, forKey: url as NSURL)
        
        // 2. Disk
        let fileURL = diskCacheURL.appendingPathComponent(url.lastPathComponent)
        if let data = image.pngData() {
            try? data.write(to: fileURL)
        }
    }
}
