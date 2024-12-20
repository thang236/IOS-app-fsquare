//
//  TabViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 02/10/2024.
//

import UIKit

class TabViewController: UITabBarController {
    var coordinator: TabBarCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.setupTabs()
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        delegate = self
    }

    private func setupTabs() {
        guard let coordinator = coordinator else {
            return
        }
        // Tạo UITabBarItems
        let homeTabItem = UITabBarItem(title: "Trang chủ", image: UIImage.homeOutline.withRenderingMode(.alwaysOriginal).withTintColor(.neutralLight), selectedImage: UIImage.homeFill)
        let cartTabItem = UITabBarItem(title: "Giỏ hàng", image: UIImage.bagOutline.withRenderingMode(.alwaysOriginal).withTintColor(.neutralLight), selectedImage: UIImage.bagFill.withRenderingMode(.alwaysOriginal))
        let orderTabItem = UITabBarItem(title: "Đơn hàng", image: UIImage.cartOutline.withRenderingMode(.alwaysOriginal).withTintColor(.neutralLight), selectedImage: UIImage.cartFill)
        let profileTabItem = UITabBarItem(title: "Hồ sơ", image: UIImage.userOutline.withRenderingMode(.alwaysOriginal).withTintColor(.neutralLight), selectedImage: UIImage.userFill)

        // Tạo view controllers cho từng tab và bọc trong UINavigationController
        let homeCoordinator = HomeCoordinator(navigationMain: coordinator.getNavigationController())
        let cartCoordinator = CartCoordinator(navigationMain: coordinator.getNavigationController())
        let homeVC = homeCoordinator.getNavigationController()
        let profileCoordinator = ProfileCoordinator(navigationMain: coordinator.getNavigationController())
        let profileVC = profileCoordinator.getNavigationController()
        let cartVC = cartCoordinator.getNavigationController()
        let orderCoordinator = OrderCoordinator(navigationMain: coordinator.getNavigationController())
        let orderVC = orderCoordinator.getNavigationController()

        homeVC.tabBarItem = homeTabItem
        cartVC.tabBarItem = cartTabItem
        orderVC.tabBarItem = orderTabItem
        profileVC.tabBarItem = profileTabItem

        setViewControllers([homeVC, cartVC, orderVC, profileVC], animated: true)

        let fontAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.interItalicVariableFont(fontWeight: .regular, size: 12) as Any,
        ]

        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .selected)

        tabBar.tintColor = .primaryDark
        tabBar.backgroundColor = UIColor.white
        tabBar.unselectedItemTintColor = .neutralLight
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.white
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}

extension TabViewController: UITabBarControllerDelegate {
    func tabBarController(_: UITabBarController, didSelect _: UIViewController) {}
}
