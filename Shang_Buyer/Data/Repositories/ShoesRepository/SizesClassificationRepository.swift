//
//  SizesClassificationRepository.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 05/11/2024.
//

import Foundation
import Combine

protocol SizesClassificationRepository {
    func getShoesSize(idClassification: String) -> AnyPublisher<SizesClassificationResponse, Error>
}

class SizeClassificationRepositoryImpl: SizesClassificationRepository {
    private let apiService: APIService

    init(apiService: APIService) {
        self.apiService = apiService
    }

    func getShoesSize(idClassification: String) -> AnyPublisher<SizesClassificationResponse, Error> {
        if TokenManager.shared.getAccessToken() != nil || TokenManager.shared.getAccessToken() != "" {
            apiService.request(endpoint: .getSizeClassification(idClassification: idClassification), method: .get, parameters: nil)
        } else {
            apiService.requestNoToken(endpoint:.getSizeClassification(idClassification: idClassification), method: .get, parameters: nil)
        }
    }
}
