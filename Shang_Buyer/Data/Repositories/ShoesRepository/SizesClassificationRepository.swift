//
//  SizesClassificationRepository.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 05/11/2024.
//

import Combine
import Foundation

protocol SizesClassificationRepository {
    func getShoesSize(idClassification: String) -> AnyPublisher<SizesClassificationResponse, Error>
}

class SizeClassificationRepositoryImpl: SizesClassificationRepository {
    private let apiService: APIService

    init(apiService: APIService) {
        self.apiService = apiService
    }

    func getShoesSize(idClassification: String) -> AnyPublisher<SizesClassificationResponse, Error> {
        apiService.request(endpoint: .getSizeClassification(idClassification: idClassification), method: .get, parameters: nil)
    }
}
