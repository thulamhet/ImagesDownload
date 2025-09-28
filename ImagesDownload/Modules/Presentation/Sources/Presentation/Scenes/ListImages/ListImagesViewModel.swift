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

final class ListImagesViewModel {

    private let router: ListImagesRouter
    @Published var photoURLs: [URL] = []
    private let service = PhotoService()
    
    init(router: ListImagesRouter) {
        self.router = router
    }
    
    func loadPhotos() async {
        photoURLs = await service.fetchPhotoURLs()
    }
}

final class PhotoService {
    func fetchPhotoURLs() async -> [URL] {
        // Fake list >=2k
        return (1...120).compactMap {
            URL(string: "https://picsum.photos/id/\($0)/2048/2048")
        }
    }
}
