//
//  GetImagesUseCase.swift
//  Domain
//
//  Created by Nguyễn Công Thư on 29/9/25.
//

import UIKit

public protocol GetImagesUseCase {
    func execute(urls: [URL],
                           completion: @escaping (Result<[UIImage?], NetworkError>) -> Void)
}

public class DefaultGetImagesUseCase: GetImagesUseCase {
    public func execute(urls: [URL],
                           completion: @escaping (Result<[UIImage?], NetworkError>) -> Void) {
       repository.fetchImages(for: urls, completion: completion)
   }
    
    private let repository: ImagesRepository
    
    public init(repository: ImagesRepository) {
        self.repository = repository
    }
}
