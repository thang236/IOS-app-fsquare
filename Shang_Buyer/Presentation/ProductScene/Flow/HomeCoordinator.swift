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
        let viewModel = DIContainer.shared.resolveLoadingViewModel()
//        let viewController = ProductListViewController(viewModel: viewModel)
        
        // test
        let vc = LoadingViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
}
