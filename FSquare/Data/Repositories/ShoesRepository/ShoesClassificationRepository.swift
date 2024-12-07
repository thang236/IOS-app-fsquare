//
//  ShoesClassificationRepository.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 04/11/2024.
//

import Combine
import Foundation

protocol ShoesClassificationRepository {
    func getShoesClassification(idShoes: String) -> AnyPublisher<ShoesClassificationsResponse, Error>
}

class ShoesClassificationsRepositoryImpl: ShoesClassificationRepository {
    private let apiService: APIService

    init(apiService: APIService) {
        self.apiService = apiService
    }

    func getShoesClassification(idShoes: String) -> AnyPublisher<ShoesClassificationsResponse, Error> {
        apiService.request(endpoint: .getShoesClassification(idShoes: idShoes), method: .get, parameters: nil)
    }
}
