//
//  TabBarCoordinator.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 07/10/2024.
//

import Foundation
import UIKit

import Foundation
import UIKit

class TabBarCoordinator: Coordinator {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let tabBarController = TabViewController()
        tabBarController.coordinator = self
        navigationController.setViewControllers([tabBarController], animated: false)
    }
}
