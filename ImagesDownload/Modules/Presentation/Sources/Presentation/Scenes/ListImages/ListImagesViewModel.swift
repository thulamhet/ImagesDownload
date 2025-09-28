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
    @Published var photos: [Photo] = []
    @Published var reloadIndex: Int = -1
    @Published var didAppendNewPage: Bool = false      // ✅ notify VC reload table
    
    private let router: ListImagesRouter
    
    // ✅ OperationQueue để giới hạn concurrent download = 3
    private let downloadQueue: OperationQueue = {
        let q = OperationQueue()
        q.maxConcurrentOperationCount = 3
        q.qualityOfService = .userInitiated
        return q
    }()
    
    private var cancellables = Set<AnyCancellable>()
    
    // ✅ Paging state
    private var currentPage = 0
    private let pageSize = 10
    private var isLoading = false
    
    init(router: ListImagesRouter) {
        self.router = router
    }
    
    // ✅ load page đầu tiên
    func loadInitialPhotos() {
        currentPage = 0
        photos.removeAll()
        didAppendNewPage = false
        loadMorePhotos()
    }
    
    // ✅ load page tiếp theo
    func loadMorePhotos() {
        guard !isLoading else { return }
        isLoading = true
        
        let start = currentPage * pageSize + 1
        let end = start + pageSize - 1
        
        let newURLs = (start...end).compactMap {
            URL(string: "https://picsum.photos/200/300?random=\($0)")
        }
        
        let startIndex = photos.count
        photos.append(contentsOf: newURLs.map { Photo(url: $0, image: nil) })
        
        currentPage += 1
        print("current page: \(currentPage)")
        isLoading = false
        didAppendNewPage = true   // ✅ notify VC
        
        // ✅ tải ảnh cho page mới
        loadImagesForRange(startIndex..<photos.count)
    }
    
    // ✅ tải ảnh cho 1 range nhất định
    private func loadImagesForRange(_ range: Range<Int>) {
        for index in range {
            let url = photos[index].url
            
            // check cache trước
            if let cached = ImageCache.shared.image(for: url) {
                photos[index].image = cached
                reloadIndex = index
                continue
            }
            
            // ✅ thêm vào downloadQueue (giới hạn 3 ảnh 1 lúc)
            downloadQueue.addOperation { [weak self] in
                guard let self = self else { return }
                
                if let data = try? Data(contentsOf: url),
                   let original = UIImage(data: data) {
                    
                    // resize
                    let thumb = original.resized(to: CGSize(width: 250, height: 200))
                    
                    if let thumb = thumb {
                        ImageCache.shared.save(thumb, for: url)
                        DispatchQueue.main.async {
                            self.photos[index].image = thumb
                            self.reloadIndex = index   // ✅ notify VC reload cell
                            print("Đã tải đến ảnh thứ \(index)")
                        }
                    }
                }
            }
        }
    }
}
