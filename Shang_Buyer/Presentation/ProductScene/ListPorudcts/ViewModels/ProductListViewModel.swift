//
//  ProductListViewModel.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 18/09/2024.
//

import Foundation
import Combine

class ProductListViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var errorMessage: String? = nil

    private let getProductsUseCase: GetProductsUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(getProductsUseCase: GetProductsUseCase) {
        self.getProductsUseCase = getProductsUseCase
    }
    func loadProducts() {
        getProductsUseCase.execute()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: {products in
                self.products = products
            } ).store(in: &cancellables)
    }
}
