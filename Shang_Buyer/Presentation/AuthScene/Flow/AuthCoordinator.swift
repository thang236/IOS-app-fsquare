//
//  AuthCoordinator.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 24/09/2024.
//

import Foundation
import UIKit

class AuthCoordinator: Coordinator {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = DIContainer.shared.resolveProductListViewModel()
        let loadingVC = LoadingViewController()
        loadingVC.coordinator = self
        navigationController.pushViewController(loadingVC, animated: true)
    }

    func goToLoginWithPassword() {
        let loginPassVC = LoginWithPassViewController()
        loginPassVC.coordinator = self
        navigationController.pushViewController(loginPassVC, animated: true)
    }

    func goToLoginMethodSelection() {
        let loginMethodViewController = LoginMethodSelectionViewController()
        loginMethodViewController.coordinator = self
        navigationController.pushViewController(loginMethodViewController, animated: true)
    }
}
