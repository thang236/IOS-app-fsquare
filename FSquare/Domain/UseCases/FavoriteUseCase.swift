//
//  FavoriteUseCase.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 20/11/2024.
//

import Combine
import Foundation

protocol FavoriteUseCase {
    func getFavoriteShoes() -> AnyPublisher<FavoriteResponse, Error>
    func deleteFavoriteShoes(idFavorite: String) -> AnyPublisher<FavoriteRemoveResponse, Error>
}

class FavoriteUseCaseImpl: FavoriteUseCase {
    private let favoriteRepository: FavoriteRepository

    init(favoriteRepository: FavoriteRepository) {
        self.favoriteRepository = favoriteRepository
    }

    func getFavoriteShoes() -> AnyPublisher<FavoriteResponse, Error> {
        return favoriteRepository.getFavoriteShoes()
    }

    func deleteFavoriteShoes(idFavorite: String) -> AnyPublisher<FavoriteRemoveResponse, Error> {
        return favoriteRepository.deleteFavoriteShoes(idFavorite: idFavorite)
    }
}
