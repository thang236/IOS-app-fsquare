//
//  ProductRepository.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 17/09/2024.
//

import Foundation
import Combine

protocol ProductRepository {
    func getProducts() -> AnyPublisher<[Product], Error>
}

class ProductRepositoryImpl: ProductRepository {
    private let apiService: APIService

    init(apiService: APIService) {
        self.apiService = apiService
    }

    func getProducts() -> AnyPublisher<[Product], Error> {
        return apiService.request(endpoint: .getProduct, method: .get, parameters: nil)
    }
    
}
