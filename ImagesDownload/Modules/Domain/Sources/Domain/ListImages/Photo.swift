//
//  Photo.swift
//  Domain
//
//  Created by Nguyễn Công Thư on 29/9/25.
//

import Foundation
import UIKit

public struct Photo {
    public let url: URL
    public var image: UIImage?
    
    public init(url: URL, image: UIImage? = nil) {
        self.url = url
        self.image = image
    }
}
