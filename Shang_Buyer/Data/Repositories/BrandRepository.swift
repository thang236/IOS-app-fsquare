//
//  BrandRepository.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 11/10/2024.
//

import Combine
import Foundation

protocol BrandRepository {
    func getBrand(parameters: [String: Any]) -> AnyPublisher<BrandResponse, Error>
}

class BrandRepositoryImpl: BrandRepository {
    private let apiService: APIService

    init(apiService: APIService) {
        self.apiService = apiService
    }

    func getBrand(parameters: [String: Any]) -> AnyPublisher<BrandResponse, Error> {
        apiService.request(endpoint: .getBrand, method: .get, parameters: parameters)
    }
}
