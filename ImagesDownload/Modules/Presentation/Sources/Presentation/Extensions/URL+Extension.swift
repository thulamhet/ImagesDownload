//
//  URL+Extension.swift
//  Presentation
//
//  Created by Nguyễn Công Thư on 29/9/25.
//

import Foundation
import CryptoKit

extension URL {
    /// Trả về tên file đã được hash SHA256 từ absoluteString của URL
    var hashedFileName: String {
        let data = Data(self.absoluteString.utf8)
        let hash = SHA256.hash(data: data)
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}
