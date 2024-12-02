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
    var homeViewModel: HomeViewModel

    init() {
        homeViewModel = DIContainer.shared.resolveHomeViewModel()
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

    func goToFavorite() {
        let favoriteViewModel = DIContainer.shared.resolveFavoriteViewModel()
        let favoriteVC = FavoriteViewController(viewModel: favoriteViewModel)
        favoriteVC.coordinator = self
        navigationController.pushViewController(favoriteVC, animated: true)
    }

    func goToProduct(titleBrand: String) {
        let productVC = ProductViewController(title: titleBrand, viewModel: homeViewModel)
        productVC.coordinator = self
        navigationController.pushViewController(productVC, animated: true)
    }
}
