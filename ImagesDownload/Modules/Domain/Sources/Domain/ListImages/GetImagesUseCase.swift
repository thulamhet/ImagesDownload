//
//  GetImagesUseCase.swift
//  Domain
//
//  Created by Nguyễn Công Thư on 29/9/25.
//

import UIKit

public protocol GetImagesUseCase {
    func execute(url: URL, completion: @escaping (Result<UIImage?, NetworkError>) -> Void)
    func cancelDownload(for url: URL)
}

public class DefaultGetImagesUseCase: GetImagesUseCase {
    private let repository: ImagesRepository
    
    public init(repository: ImagesRepository) {
        self.repository = repository
    }
    
    public func execute(url: URL, completion: @escaping (Result<UIImage?, NetworkError>) -> Void) {
        repository.downloadImage(for: url, completion: completion)
   }
    
    public func cancelDownload(for url: URL) {
        repository.cancelDownload(for: url)
    }
}
