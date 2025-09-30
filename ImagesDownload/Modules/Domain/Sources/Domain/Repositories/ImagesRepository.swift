//
//  ImagesRepository.swift
//  Domain
//
//  Created by Nguyễn Công Thư on 29/9/25.
//

import UIKit

public protocol ImagesRepository {
    func downloadImage(for url: URL, completion: @escaping (Result<UIImage?, Domain.NetworkError>) -> Void)
    func cancelDownload(for url: URL)
}
