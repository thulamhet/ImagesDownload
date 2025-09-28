//
//  ListImagesViewController.swift
//  Presentation
//
//  Created by Nguyễn Công Thư on 28/9/25.
//

import UIKit

final class ListImagesViewController: BaseViewController {
    private let viewModel: ListImagesViewModel
    @IBOutlet private weak var tableView: UITableView!
    
    init(viewModel: ListImagesViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindViewModel()
        
        viewModel.loadInitialPhotos()
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: ImageTableViewCell.viewName,
                                 bundle: Presentation.bundle),
                           forCellReuseIdentifier: ImageTableViewCell.viewName)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 200
    }
    
    private func bindViewModel() {
        // Reload cell khi ảnh tải xong
        viewModel.$reloadIndex
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index in
                guard let self = self, index >= 0 else { return }
                let indexPath = IndexPath(row: index, section: 0)
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }
            .store(in: &cancellables)
        
        // Reload table khi append thêm page mới
        viewModel.$didAppendNewPage
            .filter { $0 } // chỉ khi true
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension ListImagesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        viewModel.photos.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ImageTableViewCell.viewName,
            for: indexPath
        ) as! ImageTableViewCell
        
        let photo = viewModel.photos[indexPath.row]
        cell.configure(with: photo, at: indexPath.row)
        return cell
    }
}

extension ListImagesViewController: UITableViewDelegate {
    // Load more khi scroll tới cuối danh sách
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height * 2 { // cách đáy khoảng 2 screen height
            viewModel.loadMorePhotos()
        }
    }
}
