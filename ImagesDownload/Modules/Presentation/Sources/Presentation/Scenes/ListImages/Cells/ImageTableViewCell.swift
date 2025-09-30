//
//  ImageTableViewCell.swift
//  Presentation
//
//  Created by Nguyễn Công Thư on 28/9/25.
//

import UIKit
import Domain

final class ImageTableViewCell: UITableViewCell {
    @IBOutlet weak var photoView: UIImageView!
    var currentURL: URL?
    var cancelHandler: ((URL) -> Void)?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoView.image = UIImage(systemName: "photo")   // placeholder
        if let url = currentURL {
            cancelHandler?(url)
        }
        currentURL = nil
    }
    
    func configure(with photo: Photo) {
        currentURL = photo.url
        photoView.image = photo.image ?? UIImage(systemName: "photo")
    }
}

