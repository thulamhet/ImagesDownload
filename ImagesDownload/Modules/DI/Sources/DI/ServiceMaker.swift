//
//  ServiceMaker.swift
//  DI
//
//  Created by Nguyễn Công Thư on 28/9/25.
//

import Foundation

class ServiceMaker<T> {
    private var method: ResolverHandling<T>
    private let isSingleton: Bool
    private var singletonInstance: T?
    weak var resolver: IOCContainer?

    init(method: @escaping ResolverHandling<T>, isSingleton: Bool = false, resolver: IOCContainer) {
        self.method = method
        self.isSingleton = isSingleton
        self.resolver = resolver
    }

    func get() -> T? {
        guard let resolver = resolver else { fatalError() }

        if isSingleton && singletonInstance == nil {
            singletonInstance = method(resolver)
            method = { _ in return self.singletonInstance! }
            return singletonInstance
        }
        return method(resolver)
    }
}
