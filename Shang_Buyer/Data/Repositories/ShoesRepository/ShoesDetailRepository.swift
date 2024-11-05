//
//  ShoesDetailRepository.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 04/11/2024.
//

import Foundation
import Combine

protocol ShoesDetailRepository {
    func getShoesDetail(idShoes: String) -> AnyPublisher<ShoesDetailResponse, Error>
}

class ShoesDetailRepositoryImpl: ShoesDetailRepository {
    private let apiService: APIService

    init(apiService: APIService) {
        self.apiService = apiService
    }

    func getShoesDetail(idShoes: String) -> AnyPublisher<ShoesDetailResponse, Error> {
        if TokenManager.shared.getAccessToken() != nil || TokenManager.shared.getAccessToken() != "" {
            apiService.request(endpoint: .getDetailShoes(isLogin: false, idShoes: idShoes), method: .get, parameters: nil)
        } else {
            apiService.requestNoToken(endpoint: .getDetailShoes(idShoes: idShoes), method: .get, parameters: nil)
        }
    }
}
