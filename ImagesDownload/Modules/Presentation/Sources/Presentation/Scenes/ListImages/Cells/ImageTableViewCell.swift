//
//  ImageTableViewCell.swift
//  Presentation
//
//  Created by Nguyễn Công Thư on 28/9/25.
//

import UIKit

final class ImageTableViewCell: UITableViewCell {
    @IBOutlet private weak var photoView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoView.image = UIImage(systemName: "photo")   // placeholder
    }
    
    func configure(with photo: UIImage?, at index: Int) {
        photoView.image = photo ?? UIImage(systemName: "photo")
    }
}

