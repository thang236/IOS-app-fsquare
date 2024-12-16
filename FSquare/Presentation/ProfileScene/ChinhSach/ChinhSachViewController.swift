//
//  ChinhSachViewController.swift
//  FSquare
//
//  Created by ThangHT on 12/12/2024.
//

import UIKit

class ChinhSachViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
    }

    override func viewWillAppear(_: Bool) {
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_: Bool) {
        tabBarController?.tabBar.isHidden = false
    }

    private func setupNav() {
        navigationItem.hidesBackButton = true
        let image: UIImage = #imageLiteral(resourceName: "positionLeft")
        guard let size = navigationController?.navigationBar.frame.height else {
            return
        }
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backButtonTapped))
        button.tintColor = .black
        setupNavigationBar(leftBarButton: button, title: "Chính sách quyền riêng tư")
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
