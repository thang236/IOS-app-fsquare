//
//  GetAccountsUseCase.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 17/09/2024.
//

import Foundation
import Combine

protocol GetProductsUseCase {
    func execute() -> AnyPublisher<[Product], Error>
}

class GetProductsUseCaseImpl: GetProductsUseCase {
    private let productRepository: ProductRepository

    init(productRepository: ProductRepository) {
        self.productRepository = productRepository
    }

    func execute() -> AnyPublisher<[Product], Error> {
        return productRepository.getProducts()
    }
}
