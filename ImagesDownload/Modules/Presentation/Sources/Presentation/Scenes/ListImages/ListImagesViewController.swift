//
//  ListImagesViewController.swift
//  Presentation
//
//  Created by Nguyễn Công Thư on 28/9/25.
//

import UIKit

final class ListImagesViewController: BaseViewController {
    private let viewModel: ListImagesViewModel
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet private weak var tableView: UITableView!
    private var isLoadingData = false
    
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
        viewModel.$reloadIndex
            .sink { [weak self] index in
                guard let self = self, index >= 0 else { return }
                let indexPath = IndexPath(row: index, section: 0)
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }
            .store(in: &cancellables)
        
        viewModel.$didAppendNewPage
            .filter { $0 } // chỉ khi true
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$listImages.sink { [unowned self] newImages in
            let start = viewModel.totalImages.count - newImages.count
            let end = viewModel.totalImages.count
            let paths = (start..<end).map { IndexPath(row: $0, section: 0) }
            self.tableView.performBatchUpdates {
                self.tableView.insertRows(at: paths, with: .none)
            } completion: { success in
                if success {
                    self.isLoadingData = false
//                    self.vLoadingIndicator.stopAnimating()
                }
            }
        }.store(in: &cancellables)
        
        
        viewModel.$isLoadingPage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self else { return }
                isLoading ? loadingView.startAnimating() : loadingView.stopAnimating()
            }
            .store(in: &cancellables)
    }
}

extension ListImagesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        viewModel.totalImages.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ImageTableViewCell.viewName,
            for: indexPath
        ) as! ImageTableViewCell
        
        let photo = viewModel.totalImages[indexPath.row]
        cell.configure(with: photo, at: indexPath.row)
        return cell
    }
}

extension ListImagesViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let tableHeight = scrollView.frame.size.height
        
        if position + tableHeight > contentHeight - 100, !isLoadingData {
            isLoadingData = true
            viewModel.loadMorePhotos()
        }
    }
}


