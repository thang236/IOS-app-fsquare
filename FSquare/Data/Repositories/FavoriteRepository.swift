//
//  FavoriteRepository.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 20/11/2024.
//

import Combine
import Foundation

protocol FavoriteRepository {
    func getFavoriteShoes() -> AnyPublisher<FavoriteResponse, Error>
    func deleteFavoriteShoes(idFavorite: String) -> AnyPublisher<FavoriteRemoveResponse, Error>
}

class FavoriteRepositoryImpl: FavoriteRepository {
    private let apiService: APIService

    init(apiService: APIService) {
        self.apiService = apiService
    }

    func getFavoriteShoes() -> AnyPublisher<FavoriteResponse, Error> {
        apiService.request(endpoint: .getFavorite, method: .get, parameters: nil)
    }

    func deleteFavoriteShoes(idFavorite: String) -> AnyPublisher<FavoriteRemoveResponse, Error> {
        apiService.request(endpoint: .removeFavorite(idFavorite: idFavorite), method: .delete, parameters: nil)
    }
}
