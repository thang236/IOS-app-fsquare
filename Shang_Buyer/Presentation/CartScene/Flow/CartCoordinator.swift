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
    init() {
        let cartViewModel = DIContainer.shared.resolveCartViewModel()
        let cartVc = CartViewController(viewModel: cartViewModel)
        navigationController = UINavigationController(rootViewController: cartVc)
        cartVc.coordinator = self
    }

    func start() {}

    func getNavigationController() -> UINavigationController {
        return navigationController
    }
}
