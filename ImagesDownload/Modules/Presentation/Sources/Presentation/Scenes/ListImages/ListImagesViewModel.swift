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

final class ListImagesViewModel {
    @Inject private var getImagesUseCase: GetImagesUseCase
    @Published var photos: [Photo] = []
    @Published var reloadIndex: Int = -1
    @Published var didAppendNewPage: Bool = false
    @Published var downloadedPhotos: [Photo] = []
    @Published var isLoadingPage: Bool = false
    @Published var listImages: [UIImage?] = []
    var totalImages: [UIImage?] = []
    
    private let router: ListImagesRouter
    private let downloadQueue: OperationQueue = {
        let q = OperationQueue()
        q.maxConcurrentOperationCount = 3
        q.qualityOfService = .userInitiated
        return q
    }()
    
    private var cancellables = Set<AnyCancellable>()
    private var currentPage = 0
    private let pageSize = 10
    private var isLoading = false
    
    init(router: ListImagesRouter) {
        self.router = router
    }
    
    func loadInitialPhotos() {
        currentPage = 0
        photos.removeAll()
        didAppendNewPage = false
        loadMorePhotos()
    }
    
    func loadMorePhotos() {
        let start = currentPage * pageSize + 1
        let end = start + pageSize - 1

        let newURLs = (start...end).compactMap {
            URL(string: "https://picsum.photos/id/\($0)/2048/1365")
        }

        let startIndex = photos.count
        photos.append(contentsOf: newURLs.map { Photo(url: $0, image: nil) })
        
        currentPage += 1
        didAppendNewPage = true
        loadImagesForRange(startIndex..<photos.count)
    }
    
    private func loadImagesForRange(_ range: Range<Int>) {
        isLoadingPage = true
        getImagesUseCase.execute(urls: photos[range].map { $0.url }) { [weak self] result in
            guard let self else { return }
            isLoadingPage = false
            switch result {
                case .success(let listImages):
                    totalImages.append(contentsOf: listImages)
                    print("Đã tải tổng \(totalImages.count) ảnh")
                    self.listImages = listImages
                case .failure(_):
                    // do sth
                    break
            }
        }
    }
}
