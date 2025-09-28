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
        tableView.reloadData()
        viewModel.loadPhotos()
    }
    
    private func bindViewModel() {
        viewModel.$photos
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension ListImagesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.photos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as! ImageTableViewCell
        let photo = viewModel.photos[indexPath.row]
        cell.textLabel?.text = "Photo \(indexPath.row + 1)"
        cell.imageView?.image = photo.image ?? UIImage(systemName: "photo")
        return cell
    }
}
