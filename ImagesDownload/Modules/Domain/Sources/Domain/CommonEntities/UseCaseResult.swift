//
//  UseCaseResult.swift
//  Domain
//
//  Created by Nguyễn Công Thư on 29/9/25.
//

public enum UseCaseResult<Success, Failure> {
    case success(Success)
    case failure(Failure)
}
