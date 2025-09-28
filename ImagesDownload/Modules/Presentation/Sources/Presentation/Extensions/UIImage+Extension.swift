//
//  UIImage+Bundle.swift
//  Presentation
//
//  Created by Nguyễn Công Thư on 28/9/25.
//

import UIKit

extension UIImage {
    public convenience init?(inPresentationBundle imageName: String) {
        self.init(named: imageName, in: Presentation.bundle, compatibleWith: nil)
    }
    
    func resized(to targetSize: CGSize) -> UIImage? {
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1 
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
