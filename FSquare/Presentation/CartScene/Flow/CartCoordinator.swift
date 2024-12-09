//
//  CartCoordinator.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 22/11/2024.
//

import Foundation
import UIKit

class CartCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private var cartViewModel: CartViewModel
    private let navigationMain: UINavigationController
    
    init(navigationMain: UINavigationController) {
        self.navigationMain = navigationMain
        cartViewModel = DIContainer.shared.resolveCartViewModel()
        let cartVC = CartViewController(viewModel: cartViewModel)
        navigationController = UINavigationController(rootViewController: cartVC)
        cartVC.coordinator = self
    }

    func start() {}

    func getNavigationController() -> UINavigationController {
        return navigationController
    }

    func goToCheckOut() {
        let checkOutVC = CheckOutViewController(viewModel: cartViewModel)
        checkOutVC.coordinator = self
        navigationController.pushViewController(checkOutVC, animated: false)
    }

    func goToChooseAddress() {
        let chooseAddressVC = ChooseAddressViewController(viewModel: cartViewModel)
        navigationController.pushViewController(chooseAddressVC, animated: false)
    }

    func goToBaoKim(url: String) {
        let baoKimVC = BaoKimViewController(url: url)
        baoKimVC.coordinator = self
        navigationController.pushViewController(baoKimVC, animated: false)
    }
    
    func goToLogin() {
        let authCoordinator = AuthCoordinator(navigationController: navigationMain)
        navigationMain.isNavigationBarHidden = false
        authCoordinator.goToLoginMethodSelection()
    }
}
