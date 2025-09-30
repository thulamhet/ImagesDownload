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
        di.registerServices()
        di.registerRepositories()
        di.registerUseCases()
    }

    func registerUseCases() {
        Injector.containerInstance.register(service: GetImagesUseCase.self) { resolver in
            let rp = resolver.resolve(ImagesRepository.self)!
            return DefaultGetImagesUseCase(repository: rp)
        }
    }

    func registerRepositories() {
        Injector.containerInstance.register(service: ImagesRepository.self) { resolver in
            return DefaultImagesRepository(cache: resolver.resolve(ImageCacheProtocol.self)!)
        }
    }

    func registerServices() {
        Injector.containerInstance.register(service: ImageCacheProtocol.self) { _ in
            return ImageCache()
        }
    }
}
