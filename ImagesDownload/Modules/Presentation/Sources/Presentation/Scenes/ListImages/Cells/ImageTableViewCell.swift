//
//  ImageTableViewCell.swift
//  Presentation
//
//  Created by Nguyễn Công Thư on 28/9/25.
//

import UIKit

final class ImageTableViewCell: UITableViewCell {
    @IBOutlet private weak var photoView: UIImageView!
    
    /// Lưu URL hiện tại của cell để tránh flicker do reuse
    private var currentURL: URL?
    
    // Reset trạng thái khi cell được reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        currentURL = nil
        photoView.image = UIImage(systemName: "photo")   // placeholder
    }
    
    /// Cấu hình cell với model
    func configure(with photo: Photo, at index: Int) {
        currentURL = photo.url
        photoView.image = photo.image ?? UIImage(systemName: "photo")
    }
}

