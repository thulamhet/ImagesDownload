//
//  BaseViewController.swift
//  Presentation
//
//  Created by Nguyễn Công Thư on 28/9/25.
//

import UIKit
import Combine


// Every ViewController should inherit this class to have loading xib file from Presentation bundle
// Also have some utility functions and custom them if needed like back to previous func when pressing back
class BaseViewController: UIViewController {

    var cancellables = Set<AnyCancellable>()

    init() {
        super.init(nibName: String(describing: type(of: self)), bundle: Presentation.bundle)
    }

    @available(iOS, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        showBackButton()
    }

    func hideBackButton() {
        self.navigationItem.leftBarButtonItem = nil
    }

    func showBackButton() {
        var icon = UIImage(inPresentationBundle: "ic_navbar_arrow_left")
        icon = icon?.withRenderingMode(.alwaysOriginal)
        let backBtn = UIBarButtonItem(image: icon,
                                      style: .plain,
                                      target: self,
                                      action: #selector(self.onBackButton))
        self.navigationItem.leftBarButtonItem = backBtn
    }

    @objc func onBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
