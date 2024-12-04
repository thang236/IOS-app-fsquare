//
//  GetShoesUseCase.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 09/10/2024.
//

import Combine
import Foundation

protocol GetShoesUseCase {
    func execute(parameter: [String: Any]) -> AnyPublisher<ShoesResponse, Error>
    func addFavoriteShoes(parameter: [String: Any]) -> AnyPublisher<AddFavoriteResponse, Error>
    func removeFavoriteShoes(parameter: [String: Any]) -> AnyPublisher<FavoriteRemoveResponse, Error>
    func getPopularShoes() -> AnyPublisher<PopularResponse, Error>
}

class GetShoesUseCaseImpl: GetShoesUseCase {
    private let shoesRepository: ShoesRepository

    init(shoesRepository: ShoesRepository) {
        self.shoesRepository = shoesRepository
    }

    func execute(parameter: [String: Any]) -> AnyPublisher<ShoesResponse, Error> {
        return shoesRepository.getShoes(parameters: parameter)
    }

    func addFavoriteShoes(parameter: [String: Any]) -> AnyPublisher<AddFavoriteResponse, Error> {
        return shoesRepository.addFavoriteShoes(parameters: parameter)
    }

    func removeFavoriteShoes(parameter parameters: [String: Any]) -> AnyPublisher<FavoriteRemoveResponse, Error> {
        return shoesRepository.removeFavoriteShoes(parameters: parameters)
    }

    func getPopularShoes() -> AnyPublisher<PopularResponse, Error> {
        return shoesRepository.getPopularShoes()
    }
}
