//
//  OrderCoordinator.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 01/12/2024.
//

import Foundation
import UIKit

class OrderCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private var myOrderViewModel: MyOrderViewModel
    private let navigationMain: UINavigationController

    init(navigationMain: UINavigationController) {
        self.navigationMain = navigationMain
        myOrderViewModel = DIContainer.shared.resolveOrderViewModel()
        let myOrderVC = MyOrderViewController(viewModel: myOrderViewModel)
        navigationController = UINavigationController(rootViewController: myOrderVC)
        myOrderVC.coordinator = self
    }

    func start() {}

    func getNavigationController() -> UINavigationController {
        return navigationController
    }

    func showOrderDetail() {
        let orderDetailVC = OrderDetailViewController(viewModel: myOrderViewModel)
        navigationController.pushViewController(orderDetailVC, animated: true)
    }
    
    func goToLogin() {
        let authCoordinator = AuthCoordinator(navigationController: navigationMain)
        navigationMain.isNavigationBarHidden = false
        authCoordinator.goToLoginMethodSelection()
    }
}
