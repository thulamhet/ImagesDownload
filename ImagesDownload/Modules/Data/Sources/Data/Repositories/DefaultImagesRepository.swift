//
//  DefaultImagesRepository.swift
//  Data
//
//  Created by Nguyễn Công Thư on 29/9/25.
//

import Domain
import UIKit

public class DefaultImagesRepository: ImagesRepository {
    private let cache: ImageCacheProtocol
    private let downloadQueue: OperationQueue
    private var operations: [URL: Operation] = [:]
    
    public init(cache: ImageCacheProtocol) {
        self.cache = cache
        self.downloadQueue = OperationQueue()
        self.downloadQueue.maxConcurrentOperationCount = 3
        self.downloadQueue.qualityOfService = .userInitiated
    }
    
    public func downloadImage(for url: URL, completion: @escaping (Result<UIImage?, Domain.NetworkError>) -> Void) {
        if let cached = cache.image(for: url) {
            completion(.success(cached))
            return
        }
        
        // Nếu đã có operation đang chạy → bỏ qua
        if operations[url] != nil { return }
        
        let op = BlockOperation { [weak self] in
            guard let self = self else { return }
            
            if let data = try? Data(contentsOf: url),
               let img = UIImage(data: data) {
                
                print("Đã tải thành công url: \(url)")
                let resized = img.resized(to: CGSize(width: 250, height: 250))
                self.cache.save(resized, for: url)
                
                DispatchQueue.main.async {
                    completion(.success(resized))
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(.noData)) // để tạm
                }
            }
            
            self.operations[url] = nil
        }
        
        operations[url] = op
        downloadQueue.addOperation(op)
    }
    
    public func cancelDownload(for url: URL) {
        // Chưa finish thì ms cancel
        guard let op = operations[url], !op.isFinished else { return }
        operations[url]?.cancel()
        operations[url] = nil
        print("Cancel: \(url)")
    }
}

extension UIImage {
    func resized(to targetSize: CGSize) -> UIImage {
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
