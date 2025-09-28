//
//  ListImagesBuilder.swift
//  Presentation
//
//  Created by Nguyễn Công Thư on 28/9/25.
//

import UIKit

final class ListImagesBuilder {
    @MainActor
    static func build() -> UIViewController {
        let router = ListImagesRouter()
        let vm = ListImagesViewModel(router: router)
        let vc = ListImagesViewController(viewModel: vm)
        router.viewController = vc
        return vc
    }
}
