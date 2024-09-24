//
//  LoadingViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 20/09/2024.
//

import UIKit

class LoadingViewController: UIViewController {
    var coordinator: AuthCoordinator?
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.coordinator?.goToLoginMethodSelection()
        }
    }
}
