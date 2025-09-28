// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

public class Presentation {
    @MainActor
    public static func createRootController() -> UIViewController {
        let homeVC = HomeViewController()
        let navigation = UINavigationController(rootViewController: homeVC)
        return navigation
    }

    static var bundle: Bundle {
        let pathStyle = Bundle.main.path(forResource: "Presentation_Presentation", ofType: "bundle") ?? ""
        if let b = Bundle(path: pathStyle) {
            return b
        }
        return .main
    }
}
