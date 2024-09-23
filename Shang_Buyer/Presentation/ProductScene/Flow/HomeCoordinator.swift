//
//  HomeCoordinator.swift
//  CombineMVVMUIKitExample
//
//  Created by Louis Macbook on 11/09/2024.
//

import Foundation
import UIKit

class HomeCoordinator: Coordinator {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = DIContainer.shared.resolveProductListViewModel()
        let viewController = ProductListViewController(viewModel: viewModel)
        viewController.coordinator = self
        // test
        let vc = LoadingViewController()
        navigationController.pushViewController(vc, animated: true)
    }
}
