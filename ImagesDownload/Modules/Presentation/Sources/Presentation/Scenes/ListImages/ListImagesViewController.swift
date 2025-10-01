//
//  ListImagesViewController.swift
//  Presentation
//
//  Created by Nguyễn Công Thư on 28/9/25.
//

import UIKit

final class ListImagesViewController: BaseViewController {
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet private weak var tableView: UITableView!
    private var isLoadingData = false
    private let viewModel: ListImagesViewModel
    
    init(viewModel: ListImagesViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Danh sách ảnh"
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: ImageTableViewCell.viewName,
                                 bundle: Presentation.bundle),
                           forCellReuseIdentifier: ImageTableViewCell.viewName)
        
        tableView.dataSource = self
        tableView.rowHeight = 200
    }
}

extension ListImagesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        viewModel.photos.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ImageTableViewCell.viewName,
            for: indexPath
        ) as? ImageTableViewCell else {
            return .init()
        }
        
        let photo = viewModel.photos[indexPath.row]
        cell.configure(with: photo)
        cell.cancelHandler = { [weak self] url in
           self?.viewModel.cancelDownload(url: url)
        }
        viewModel.downloadImage(for: photo.url) { image in
            if cell.currentURL == photo.url {
                cell.photoView.image = image
            }
        }
        return cell
    }
}
