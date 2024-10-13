//
//  ShoesRepository.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 09/10/2024.
//

import Combine
import Foundation

protocol ShoesRepository {
    func getShoes(parameters: [String: Any]) -> AnyPublisher<ShoesResponse, Error>
}

class ShoesRepositoryImpl: ShoesRepository {
    private let apiService: APIService

    init(apiService: APIService) {
        self.apiService = apiService
    }

    func getShoes(parameters: [String: Any]) -> AnyPublisher<ShoesResponse, Error> {
        apiService.requestNoToken(endpoint: .getShoes, method: .get, parameters: parameters)
    }
}
