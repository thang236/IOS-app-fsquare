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
    init() {
        myOrderViewModel = DIContainer.shared.resolveOrderViewModel()
        let myOrderVC = MyOrderViewController(viewModel: myOrderViewModel)
        navigationController = UINavigationController(rootViewController: myOrderVC)
        myOrderVC.coordinator = self
    }

    func start() {}

    func getNavigationController() -> UINavigationController {
        return navigationController
    }

    
}
