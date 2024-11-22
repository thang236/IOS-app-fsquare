//
//  ClassificationRepository.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 05/11/2024.
//

import Combine
import Foundation

protocol ClassificationRepository {
    func getClassification(idClassification: String) -> AnyPublisher<ClassificationsResponse, Error>
}

class ClassificationRepositoryImpl: ClassificationRepository {
    private let apiService: APIService

    init(apiService: APIService) {
        self.apiService = apiService
    }

    func getClassification(idClassification: String) -> AnyPublisher<ClassificationsResponse, Error> {
        apiService.request(endpoint: .getClassifications(idClassification: idClassification), method: .get, parameters: nil)
    }
}
