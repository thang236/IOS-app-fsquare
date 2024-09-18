//
//  ProductListViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 18/09/2024.
//

import UIKit
import Combine

class ProductListViewController: UIViewController {
    var coordinator: HomeCoordinator?
    private var viewModel: ProductListViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: ProductListViewModel) {
            self.viewModel = viewModel
            super.init(nibName: nil, bundle: nil)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupBindings()
        viewModel.loadProducts()
        
    }
    
    private func setupBindings(){
        viewModel.$products.receive(on: DispatchQueue.main).sink{ [weak self] products in
            self?.updateUI(with: products)
        }.store(in: &cancellables)
        
        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main).sink{ [weak self] errorMessage in
            self?.showError(message: errorMessage!)
        }.store(in: &cancellables)
    }
    
    private func updateUI(with products: [Product]) {
            products.forEach { product in
                print("Product: \(product.name) - Price: \(product.price)")
            }
        }
    
    private func showError(message: String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }



}
