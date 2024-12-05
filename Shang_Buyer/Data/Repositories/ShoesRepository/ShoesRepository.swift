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
    func getPopularShoes() -> AnyPublisher<PopularResponse, Error>
    func getHistory() -> AnyPublisher<HistoryResponse, Error>
    func deleteHistory(idHistory: String) -> AnyPublisher<DeleteHistoryResponse, Error>
    func postHistory(keyWord: String) -> AnyPublisher<PostHistoryResponse, Error>
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

    func getPopularShoes() -> AnyPublisher<PopularResponse, Error> {
        apiService.request(endpoint: .getPopularShoes, method: .get, parameters: nil)
    }

    func getHistory() -> AnyPublisher<HistoryResponse, Error> {
        apiService.request(endpoint: .history, method: .get, parameters: nil)
    }

    func deleteHistory(idHistory: String) -> AnyPublisher<DeleteHistoryResponse, Error> {
        apiService.request(endpoint: .historyID(idHistory: idHistory), method: .delete, parameters: nil)
    }

    func postHistory(keyWord: String) -> AnyPublisher<PostHistoryResponse, Error> {
        apiService.request(endpoint: .history, method: .post, parameters: ["keyword": keyWord])
    }
}
