//
//  AddBagRepository.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 22/11/2024.
//

import Combine
import Foundation

protocol AddBagRepository {
    func addBag(parameter: [String: Any]) -> AnyPublisher<AddBagResponse, Error>
}

class AddBagRepositoryImpl: AddBagRepository {
    let apiService: APIService

    init(apiService: APIService) {
        self.apiService = apiService
    }

    func addBag(parameter: [String: Any]) -> AnyPublisher<AddBagResponse, Error> {
        apiService.request(endpoint: .bag, method: .post, parameters: parameter)
    }
}
