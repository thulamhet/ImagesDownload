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
        tableView.register(UINib(nibName: ImageTableViewCell.viewName, bundle: Presentation.bundle), forCellReuseIdentifier: ImageTableViewCell.viewName)
        tableView.dataSource = self
        tableView.rowHeight = 250

        Task {
            await viewModel.loadPhotos()
            tableView.reloadData()
        }
    }
    
}

extension ListImagesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.photoURLs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as! ImageTableViewCell
        let url = viewModel.photoURLs[indexPath.row]
        cell.configure(with: url)
        return cell
    }
}
