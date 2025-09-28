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
}
