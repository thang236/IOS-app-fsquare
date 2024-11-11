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
        let homeTabItem = UITabBarItem(title: "Home", image: UIImage.homeOutline.withRenderingMode(.alwaysOriginal).withTintColor(.neutralLight), selectedImage: UIImage.homeFill)
        let cartTabItem = UITabBarItem(title: "Cart", image: UIImage.bagOutline.withRenderingMode(.alwaysOriginal).withTintColor(.neutralLight), selectedImage: UIImage.bagFill.withRenderingMode(.alwaysOriginal))
        let orderTabItem = UITabBarItem(title: "Orders", image: UIImage.cartOutline.withRenderingMode(.alwaysOriginal).withTintColor(.neutralLight), selectedImage: UIImage.cartFill)
        let walletTabItem = UITabBarItem(title: "Wallet", image: UIImage.walletOutline.withRenderingMode(.alwaysOriginal).withTintColor(.neutralLight), selectedImage: UIImage.walletFill)
        let profileTabItem = UITabBarItem(title: "Profile", image: UIImage.userOutline.withRenderingMode(.alwaysOriginal).withTintColor(.neutralLight), selectedImage: UIImage.userFill)

        // Tạo view controllers cho từng tab và bọc trong UINavigationController
        let homeCoordinator = HomeCoordinator()
        let homeVC = homeCoordinator.getNavigationController()
        let profileCoordinator = ProfileCoordinator()
        let profileVC = profileCoordinator.getNavigationController()
        let cartVC = UINavigationController(rootViewController: CartViewController())
        let orderVC = UINavigationController(rootViewController: MyOrderViewController())
        let walletVC = UINavigationController(rootViewController: MyEWalletViewController())

        homeVC.tabBarItem = homeTabItem
        cartVC.tabBarItem = cartTabItem
        orderVC.tabBarItem = orderTabItem
        walletVC.tabBarItem = walletTabItem
        profileVC.tabBarItem = profileTabItem

        setViewControllers([homeVC, cartVC, orderVC, walletVC, profileVC], animated: true)

        let fontAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.interItalicVariableFont(fontWeight: .regular, size: 12) as Any,
        ]

        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .selected)

        tabBar.tintColor = .primaryDark
        tabBar.backgroundColor = .white
        tabBar.unselectedItemTintColor = .neutralLight
    }
}

extension TabViewController: UITabBarControllerDelegate {
    func tabBarController(_: UITabBarController, didSelect _: UIViewController) {
//        // Kiểm tra xem viewController đã chọn là loại UINavigationController không
//        if let navController = viewController as? UINavigationController {
//            let topViewController = navController.topViewController
//
//            if topViewController is ProfileViewController {
//                // Nếu đã ở trên ProfileViewController, không cần gọi coordinator nữa
//                return
//            }
//        }
//
//        // Gọi coordinator để điều hướng đến Profile nếu người dùng nhấn vào tab Profile
//        if let navController = viewController as? UINavigationController,
//           let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController)
//        {
//            if selectedIndex == 4 { // Giả sử tab Profile là tab thứ 5 (index 4)
        ////                coordinator?.goToProfile()  Gọi coordinator để điều hướng đến Profile
//            }
//        }
    }
}
