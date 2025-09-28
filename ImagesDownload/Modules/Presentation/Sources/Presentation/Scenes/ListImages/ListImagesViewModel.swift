//
//  ListImagesViewModel.swift
//  Presentation
//
//  Created by Nguyễn Công Thư on 28/9/25.
//

import Domain
import DI
import Combine
import Foundation
import UIKit

struct Photo {
    let url: URL
    var image: UIImage?
}

final class ListImagesViewModel {
    private let router: ListImagesRouter
    private var cancellables = Set<AnyCancellable>()
    @Published var photos: [Photo] = []
    
    init(router: ListImagesRouter) {
        self.router = router
        let urls = (1...10).compactMap {
            URL(string: "https://picsum.photos/200/300?random=\($0)")
        }
        photos = urls.map { Photo(url: $0, image: nil) }
    }
    
    func loadPhotos() {
        for (index, photo) in photos.enumerated() {
            // Check cache trước
            if let cached = ImageCache.shared.image(for: photo.url) {
                self.photos[index].image = cached
                continue
            }
            
            // Nếu không có cache → download
            URLSession.shared.dataTaskPublisher(for: photo.url)
                .map { UIImage(data: $0.data) }
                .replaceError(with: nil)
                .receive(on: DispatchQueue.main)
                .sink { image in
                    guard let original = image else { return }
                    
                    // Resize trước khi cache
                    let thumbSize = CGSize(width: 150, height: 150)
                    let thumbnail = original.resized(to: thumbSize)
                    
                    if let thumb = thumbnail {
                        ImageCache.shared.save(thumb, for: photo.url)  // Lưu bản thu nhỏ
                    }
                }
                .store(in: &cancellables)
        }
    }
}
