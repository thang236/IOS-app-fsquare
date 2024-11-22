//
//  ShoesRepository.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 09/10/2024.
//

import Combine
import Foundation

protocol ShoesRepository {
    func addFavoriteShoes(parameters: [String: Any]) -> AnyPublisher<AddFavoriteResponse, Error>
    func getShoes(parameters: [String: Any]) -> AnyPublisher<ShoesResponse, Error>
    func removeFavoriteShoes(parameters: [String: Any]) -> AnyPublisher<FavoriteRemoveResponse, Error>
}

class ShoesRepositoryImpl: ShoesRepository {
    private let apiService: APIService

    init(apiService: APIService) {
        self.apiService = apiService
    }

    func addFavoriteShoes(parameters: [String: Any]) -> AnyPublisher<AddFavoriteResponse, Error> {
        apiService.request(endpoint: .addFav, method: .post, parameters: parameters)
    }

    func getShoes(parameters: [String: Any]) -> AnyPublisher<ShoesResponse, Error> {
        apiService.request(endpoint: .getShoes, method: .get, parameters: parameters)
    }

    func removeFavoriteShoes(parameters: [String: Any]) -> AnyPublisher<FavoriteRemoveResponse, Error> {
        apiService.request(endpoint: .addFav, method: .post, parameters: parameters)
    }
}
