//
//  IOCContainer.swift
//  DI
//
//  Created by Nguyễn Công Thư on 28/9/25.
//

import Foundation

public protocol ResolverProtocol {
    func resolve<Service>(_ serviceType: Service.Type) -> Service?
}

public typealias ResolverHandling<T> = (ResolverProtocol) -> T

public class IOCContainer {
    private var services: [String: ServiceMaker<Any>]

    public init() {
        self.services = [:]
    }

    public func register<Service>(service: Service.Type, isSingleton: Bool = false, factory: @escaping ResolverHandling<Service>) {
        let serviceName = String(describing: Service.self)

        services[serviceName] = ServiceMaker<Any>(method: factory, isSingleton: isSingleton, resolver: self)
    }
}

extension IOCContainer: ResolverProtocol {
    public func resolve<Service>(_ serviceType: Service.Type) -> Service? {
        let instanceName = String(describing: Service.self)
        let instance = services[instanceName]?.get()

        return instance as? Service
    }
}
