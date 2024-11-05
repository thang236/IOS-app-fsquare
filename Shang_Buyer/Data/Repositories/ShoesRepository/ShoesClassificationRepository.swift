//
//  ShoesClassificationRepository.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 04/11/2024.
//

import Foundation
import Combine

protocol ShoesClassificationRepository {
    func getShoesClassification(idShoes: String) -> AnyPublisher<ShoesClassificationsResponse, Error>
}

class ShoesClassificationsRepositoryImpl: ShoesClassificationRepository {
    private let apiService: APIService

    init(apiService: APIService) {
        self.apiService = apiService
    }

    func getShoesClassification(idShoes: String) -> AnyPublisher<ShoesClassificationsResponse, Error> {
        if TokenManager.shared.getAccessToken() != nil || TokenManager.shared.getAccessToken() != "" {
            apiService.request(endpoint: .getShoesClassification(idShoes: idShoes), method: .get, parameters: nil)
        } else {
            apiService.requestNoToken(endpoint: .getShoesClassification(idShoes: idShoes), method: .get, parameters: nil)
        }
    }
}

