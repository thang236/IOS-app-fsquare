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
        let viewModel = DIContainer.shared.resolveLoadingViewModel()
        let loadingVC = LoadingViewController(viewModel: viewModel)
        loadingVC.coordinator = self
        navigationController.pushViewController(loadingVC, animated: true)
    }

    func goToLoginMethodSelection() {
        let loginMethodViewController = LoginMethodSelectionViewController()
        loginMethodViewController.coordinator = self
        navigationController.pushViewController(loginMethodViewController, animated: true)
    }

    func goToLoginByEmail() {
        let viewModel = DIContainer.shared.resolveLoginEmailViewModel()
        let loginEmailVC = LoginWithEmailViewController(viewModel: viewModel)
        loginEmailVC.coordinator = self
        navigationController.pushViewController(loginEmailVC, animated: true)
    }

    func gotoRegisterScreen() {
        let viewModel = DIContainer.shared.resolveRegisterViewModel()
        let registerVC = RegisterViewController(viewModel: viewModel)
        registerVC.coordinator = self
        navigationController.pushViewController(registerVC, animated: true)
    }

    func goToVerifyOTP(vc: VerifyOTPViewControllerDelegate, email: String, isLogin: Bool = false) {
        let viewModel = DIContainer.shared.resolveVerifyAthViewModel()
        let verifyOTP = VerifyOTPViewController(viewModel: viewModel, email: email, isLogin: isLogin)
        verifyOTP.coordinator = self
        verifyOTP.delegate = vc.self
        navigationController.pushViewController(verifyOTP, animated: true)
    }

    func gotoSuccessRegister() {
        let successVc = SuccessfullyRegisterViewController()
        successVc.coordinator = self
        navigationController.pushViewController(successVc, animated: true)
    }
}
