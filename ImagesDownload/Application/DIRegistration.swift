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
        Injector.containerInstance.register(service: GetImagesUseCase.self) { resolver in
            let rp = resolver.resolve(ImagesRepository.self)!
            return DefaultGetImagesUseCase(repository: rp)
        }
    }

    func registerRepositories() {
        Injector.containerInstance.register(service: ImagesRepository.self) { resolver in
            return DefaultImagesRepository()
        }
    }

    func registerServices() {
//        Injector.containerInstance.register(service: NetworkService.self) { _ in
//            return NetworkService()
//        }
    }
}
