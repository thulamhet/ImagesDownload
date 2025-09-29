//
//  DefaultImagesRepository.swift
//  Data
//
//  Created by Nguyễn Công Thư on 29/9/25.
//

import Domain
import UIKit

public class DefaultImagesRepository: ImagesRepository {
    public func fetchImages(for urls: [URL],
                            completion: @escaping (Result<[UIImage?], Domain.NetworkError>) -> Void) {
        var results = Array<UIImage?>(repeating: nil, count: urls.count)
        let group = DispatchGroup()
        
        for (index, url) in urls.enumerated() {
            if let cached = cache.image(for: url) {
                results[index] = cached
                continue
            }
            
            group.enter()
            let op = BlockOperation { [weak self] in
                defer { group.leave() }
                guard let self = self else { return }
                
                if let data = try? Data(contentsOf: url),
                   let img = UIImage(data: data),
                   let thumb = img.resized(to: CGSize(width: 250, height: 200)) {
                    self.cache.save(thumb, for: url)
                    results[index] = thumb
                } else {
                    results[index] = nil
                }
            }
            downloadQueue.addOperation(op)
        }
        
        group.notify(queue: .main) {
            completion(.success(results))
        }
    }

    
    private let cache: ImageCache
    private let downloadQueue: OperationQueue
    
    public init(cache: ImageCache = .shared) {
        self.cache = cache
        self.downloadQueue = OperationQueue()
        self.downloadQueue.maxConcurrentOperationCount = 3
        self.downloadQueue.qualityOfService = .userInitiated
    }
}

extension UIImage {
    func resized(to targetSize: CGSize) -> UIImage? {
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
