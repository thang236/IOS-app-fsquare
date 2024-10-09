//
//  HomeViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 02/10/2024.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet private var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground() // Đặt nền không trong suốt
            appearance.backgroundColor = .primaryDark // Hoặc màu bạn muốn
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.standardAppearance = appearance
        }
    }

    private func setupNavigationBar() {
        let image = UIImage.logoBanner
        let logoButton = UIBarButtonItem(image: image.withRenderingMode(.alwaysOriginal), style: .done, target: nil, action: nil)
        navigationItem.leftBarButtonItem = logoButton

        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(didTapSearchButton))
        searchButton.tintColor = .white

        let favoriteButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(didTapFavorite))
        favoriteButton.tintColor = .white
        navigationItem.rightBarButtonItems = [favoriteButton, searchButton]

        navigationController?.navigationBar.barTintColor = .primaryDark
    }

    @objc func didTapSearchButton() {}

    @objc func didTapFavorite() {}
}

extension HomeViewController: UIScrollViewDelegate {}
