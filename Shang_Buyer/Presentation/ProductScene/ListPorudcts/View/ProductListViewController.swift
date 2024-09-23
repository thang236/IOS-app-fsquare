//
//  ProductListViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 18/09/2024.
//

import Combine
import UIKit

class ProductListViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    var coordinator: HomeCoordinator?
    private var viewModel: ProductListViewModel
    private var cancellables = Set<AnyCancellable>()
    
    
    init(viewModel: ProductListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupBindings()
        viewModel.loadProducts()
        configLanguage()
    }
    private func configLanguage(){
        label.text = String.localized(.greeting)
    }
    
    private func setupBindings() {
        viewModel.$products.receive(on: DispatchQueue.main).sink { [weak self] products in
            self?.updateUI(with: products)
        }.store(in: &cancellables)
        
        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main).sink { [weak self] errorMessage in
                self?.showError(message: errorMessage!)
            }.store(in: &cancellables)
    }
    
    private func updateUI(with products: [Product]) {
        for product in products {
            print("Product: \(product.name) - Price: \(product.price)")
        }
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension String {
    static func localized(_ key: LocalizedKey, tableName: String = "Localizable") -> String {
            return NSLocalizedString(key.rawValue, tableName: tableName, bundle: .main, value: "", comment: "")
        }
    
    
}
