//
//  DIRegistration.swift
//  ImagesManage
//
//  Created by Nguyễn Công Thư on 28/9/25.
//

import Foundation
import DI
import Domain
import Data

final class DIRegistration {

    static func load() {
        let di = DIRegistration()
        di.registerRepositories()
        di.registerUseCases()
        di.registerServices()
    }

    func registerUseCases() {
//        Injector.containerInstance.register(service: ListUsersUseCase.self) { resolver in
//            let rp = resolver.resolve(UserRepository.self)!
//            return DefaultListUsersUseCase(repository: rp)
//        }
    }

    func registerRepositories() {
//        Injector.containerInstance.register(service: UserRepository.self) { resolver in
//            let networkService = resolver.resolve(NetworkService.self)!
//            return DefaultListUsersRepository(networkService: networkService)
//        }
    }

    func registerServices() {
//        Injector.containerInstance.register(service: NetworkService.self) { _ in
//            return NetworkService()
//        }
    }
}
