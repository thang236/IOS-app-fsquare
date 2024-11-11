//
//  HomeCoordinator.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 10/10/2024.
//

import Foundation
import UIKit

class HomeCoordinator: Coordinator {
    private let navigationController: UINavigationController

    init() {
        let homeViewModel = DIContainer.shared.resolveHomeViewModel()
        let homeVC = HomeViewController(viewModel: homeViewModel)
        navigationController = UINavigationController(rootViewController: homeVC)
        homeVC.coordinator = self
    }

    func getNavigationController() -> UINavigationController {
        return navigationController
    }

    func start() {}

    func goToShoesDetail(idShoes: String) {
        let shoesDetailViewModel = DIContainer.shared.resolveShoesDetailViewModel()
        let shoesDetailVC = ShoeDetailViewController(shoesID: idShoes, viewModel: shoesDetailViewModel)
        navigationController.pushViewController(shoesDetailVC, animated: true)
    }
}
