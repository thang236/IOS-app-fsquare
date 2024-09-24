//
//  Coordinator.swift
//  CombineMVVMUIKitExample
//
//  Created by Louis Macbook on 11/09/2024.
//

import Foundation
import UIKit

protocol Coordinator {
    func start()
}

class AppCoordinator: Coordinator {
    private let window: UIWindow
    private let navigationController: UINavigationController

    init(window: UIWindow) {
        self.window = window
        navigationController = UINavigationController()
    }

    func start() {
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        authCoordinator.start()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
