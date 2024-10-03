//
//  HomeViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 02/10/2024.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
            navigationController?.navigationBar.barTintColor = UIColor.primaryDark
        
        scrollView.delegate = self


    }
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
//        edgesForExtendedLayout = []

       }

    
    private func setupNavigationBar() {
        let image = UIImage.logoBanner
        let logoButton = UIBarButtonItem(image: image.withRenderingMode(.alwaysOriginal), style: .done, target: nil, action: nil)
        navigationItem.leftBarButtonItem = logoButton
        
        
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(didTapSearchButton))
        searchButton.tintColor = .white
        
        let favoriteButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(didTapFavorite))
        favoriteButton.tintColor = .white
        navigationItem.rightBarButtonItems = [favoriteButton ,searchButton]
        
    }
    
    @objc func didTapSearchButton() {
        
    }
    
    @objc func didTapFavorite() {
        
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        print(offsetY)
        if offsetY > 0 {
            navigationController?.navigationBar.barTintColor = .primaryDark
            navigationController?.navigationBar.backgroundColor = UIColor.primaryDark
            
        }
    }

}

