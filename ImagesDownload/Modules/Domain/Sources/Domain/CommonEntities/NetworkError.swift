//
//  NetworkError.swift
//  Domain
//
//  Created by Nguyễn Công Thư on 29/9/25.
//

import Foundation

public enum NetworkError: Error {
    case invalidResponse
    case systemError
    case noData
    case invalidUrl
}
