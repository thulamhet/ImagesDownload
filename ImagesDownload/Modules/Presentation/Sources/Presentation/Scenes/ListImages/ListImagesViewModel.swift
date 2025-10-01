//
//  ListImagesViewModel.swift
//  Presentation
//
//  Created by Nguyễn Công Thư on 28/9/25.
//

import Domain
import DI
import Foundation
import UIKit

final class ListImagesViewModel {
    @Inject private var getImagesUseCase: GetImagesUseCase
    var photos: [Photo] = []
    
    private let router: ListImagesRouter
    private var isLoading = false
    
    init(router: ListImagesRouter) {
        self.router = router
        loadPhotos()
    }
    
    func loadPhotos() {
        let listURLs = (1...110).compactMap {
            URL(string: "https://picsum.photos/id/\($0)/2048/1365")
        }
        photos.append(contentsOf: listURLs.map { Photo(url: $0, image: nil) })
    }
    
    func downloadImage(for url: URL, completion: @escaping (UIImage?) -> Void) {
       getImagesUseCase.execute(url: url) { result in
           switch result {
               case .success(let success):
                   completion(success)
               case .failure(_):
                   break
           }
       }
    }
    
    func cancelDownload(url: URL) {
        getImagesUseCase.cancelDownload(for: url)
    }
}
