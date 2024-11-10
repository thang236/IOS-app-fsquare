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

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let homeViewModel = DIContainer.shared.resolveHomeViewModel()
        let homeVC = HomeViewController(viewModel: homeViewModel)
        homeVC.coordinator = self
        navigationController.pushViewController(homeVC, animated: true)
    }

    func getHome() -> HomeViewController {
        let homeViewModel = DIContainer.shared.resolveHomeViewModel()
        let homeVC = HomeViewController(viewModel: homeViewModel)
        homeVC.coordinator = self
        return homeVC
    }

    func goToShoesDetail(idShoes: String, navigation: UINavigationController) {
        let shoesDetailViewModel = DIContainer.shared.resolveShoesDetailViewModel()
        let shoesDetailVC = ShoeDetailViewController(shoesID: idShoes, viewModel: shoesDetailViewModel)
        navigation.pushViewController(shoesDetailVC, animated: true)
    }
}
