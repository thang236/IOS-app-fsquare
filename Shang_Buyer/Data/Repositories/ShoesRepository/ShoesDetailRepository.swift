//
//  ShoesDetailRepository.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 04/11/2024.
//

import Combine
import Foundation

protocol ShoesDetailRepository {
    func getShoesDetail(idShoes: String) -> AnyPublisher<ShoesDetailResponse, Error>
}

class ShoesDetailRepositoryImpl: ShoesDetailRepository {
    private let apiService: APIService

    init(apiService: APIService) {
        self.apiService = apiService
    }

    func getShoesDetail(idShoes: String) -> AnyPublisher<ShoesDetailResponse, Error> {
        apiService.request(endpoint: .getDetailShoes(idShoes: idShoes), method: .get, parameters: nil)
    }
}
