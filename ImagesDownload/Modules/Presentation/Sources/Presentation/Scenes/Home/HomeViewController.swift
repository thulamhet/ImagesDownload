//
//  HomeViewController.swift
//  Presentation
//
//  Created by Nguyễn Công Thư on 28/9/25.
//

import UIKit

final class HomeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        hideBackButton()
    }
    
    @IBAction func moveToListImages(_ sender: Any) {
        let vc = ListImagesBuilder.build()
        navigationController?.pushViewController(vc, animated: true)
    }
}
