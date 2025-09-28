//
//  Injector.swift
//  DI
//
//  Created by Nguyễn Công Thư on 28/9/25.
//

@propertyWrapper
public struct Inject<Dependency> {
    public var wrappedValue: Dependency

    public init() {
        self.wrappedValue = Injector.resolve(Dependency.self)!
    }
}


public final class Injector {
    public static let shared = Injector()
    private let container: IOCContainer

    private init() {
        container = IOCContainer()
    }

    public class func resolve<T>(_ type: T.Type) -> T? {
        return shared.container.resolve(type)
    }


    public static var containerInstance: IOCContainer {
        return shared.container
    }
}
