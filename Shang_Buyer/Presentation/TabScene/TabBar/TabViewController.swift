//
//  TabViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 02/10/2024.
//

import UIKit

class TabViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()

        DispatchQueue.main.async {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    private func setupTabs() {
        let profileViewModel = DIContainer.shared.resolveProfileViewModel()
        let home = createNav(title: "Home", unSelectedImage: UIImage.homeOutline, selectedImage: UIImage.homeFill, vc: HomeViewController())
        let cart = createNav(title: "Cart", unSelectedImage: UIImage.bagOutline, selectedImage: UIImage.bagFill, vc: CartViewController())
        let order = createNav(title: "Orders", unSelectedImage: UIImage.cartOutline, selectedImage: UIImage.cartFill, vc: MyOrderViewController())
        let wallet = createNav(title: "Wallet", unSelectedImage: UIImage.walletOutline, selectedImage: UIImage.walletFill, vc: MyEWalletViewController())
        let profile = createNav(title: "Profile", unSelectedImage: UIImage.userOutline, selectedImage: UIImage.userFill, vc: ProfileViewController(viewModel: profileViewModel))

        setViewControllers([home, cart, order, wallet, profile], animated: true)
        let fontAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.interItalicVariableFont(fontWeight: .regular, size: 12) as Any,
        ]

        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .selected)

        tabBar.tintColor = .primaryDark
        tabBar.backgroundColor = .white
        tabBar.unselectedItemTintColor = .neutralLight
    }

    private func createNav(title: String, unSelectedImage: UIImage?, selectedImage: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = unSelectedImage?.withRenderingMode(.alwaysOriginal).withTintColor(.neutralLight)
        nav.tabBarItem.selectedImage = selectedImage?.withRenderingMode(.alwaysOriginal)

        return nav
    }
}
