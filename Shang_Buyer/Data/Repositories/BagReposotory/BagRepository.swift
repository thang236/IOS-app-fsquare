//
//  BagRepository.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 22/11/2024.
//

import Combine
import Foundation

protocol BagRepository {
    func getBag() -> AnyPublisher<BagResponse, Error>
    func removeBag(idBag: String) -> AnyPublisher<BagDeleteResponse, Error>
    func removeAllBag() -> AnyPublisher<BagDeleteResponse, Error>
    func patchBag(idBag: String, parameters: [String: Any]) -> AnyPublisher<BagPatchResponse, Error>
}

class BagRepositoryImpl: BagRepository {
    private let apiService: APIService

    init(apiService: APIService) {
        self.apiService = apiService
    }

    func getBag() -> AnyPublisher<BagResponse, Error> {
        apiService.request(endpoint: .bag, method: .get, parameters: nil)
    }

    func removeBag(idBag: String) -> AnyPublisher<BagDeleteResponse, Error> {
        apiService.request(endpoint: .bagID(idBag: idBag), method: .delete, parameters: nil)
    }

    func removeAllBag() -> AnyPublisher<BagDeleteResponse, Error> {
        apiService.request(endpoint: .bag, method: .delete, parameters: nil)
    }

    func patchBag(idBag: String, parameters: [String: Any]) -> AnyPublisher<BagPatchResponse, Error> {
        apiService.request(endpoint: .bagID(idBag: idBag), method: .patch, parameters: parameters)
    }
}
