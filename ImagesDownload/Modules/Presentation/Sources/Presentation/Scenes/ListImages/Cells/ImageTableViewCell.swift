//
//  ImageTableViewCell.swift
//  Presentation
//
//  Created by Nguyễn Công Thư on 28/9/25.
//

import UIKit

final class ImageTableViewCell: UITableViewCell {
    @IBOutlet private weak var photoView: UIImageView!
    
    private var currentURL: URL?

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func configure(with url: URL) {
        currentURL = url
    }
}
