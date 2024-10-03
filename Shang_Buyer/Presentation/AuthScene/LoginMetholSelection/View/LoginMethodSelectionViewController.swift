//
//  LoginMethodSelectionViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 24/09/2024.
//

import UIKit

class LoginMethodSelectionViewController: UIViewController {
    var coordinator: AuthCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true

        // Do any additional setup after loading the view.
    }

    @IBAction func didTapSignUp(_: Any) {
        coordinator?.gotoRegisterScreen()
    }

    @IBAction func didTapSignIn(_: Any) {
        coordinator?.goToLoginByEmail()
    }
}
