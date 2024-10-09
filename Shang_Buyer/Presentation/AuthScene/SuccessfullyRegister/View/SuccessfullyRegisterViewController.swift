//
//  SuccessfullyRegisterViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 30/09/2024.
//

import UIKit

class SuccessfullyRegisterViewController: UIViewController {
    var coordinator: AuthCoordinator?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
    }

    @IBAction func didTapExploreButton(_: Any) {
        coordinator?.didFinishAuthentication()
    }
}
