//
//  ClassificationRepository.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 05/11/2024.
//

import Foundation
import Combine

protocol ClassificationRepository {
    func getClassification(idClassification: String) -> AnyPublisher<ClassificationsResponse, Error>
}

class ClassificationRepositoryImpl: ClassificationRepository {
    private let apiService: APIService

    init(apiService: APIService) {
        self.apiService = apiService
    }

    func getClassification(idClassification: String) -> AnyPublisher<ClassificationsResponse, Error> {
        if TokenManager.shared.getAccessToken() != nil || TokenManager.shared.getAccessToken() != "" {
            apiService.request(endpoint: .getClassifications(idClassification: idClassification), method: .get, parameters: nil)
        } else {
             apiService.requestNoToken(endpoint: .getClassifications(idClassification: idClassification), method: .get, parameters: nil)
        }
    }
}
