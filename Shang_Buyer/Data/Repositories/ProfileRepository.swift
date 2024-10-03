//
//  ProfileRepository.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 01/10/2024.
//

import Combine
import Foundation

protocol ProfileRepository {
    func getProfile() -> AnyPublisher<ProfileResponse, Error>
}

class ProfileRepositoryImpl: ProfileRepository {
    private let apiService: APIService

    init(apiService: APIService) {
        self.apiService = apiService
    }

    func getProfile() -> AnyPublisher<ProfileResponse, Error> {
        apiService.request(endpoint: .getProfile, method: .get, parameters: nil)
    }
}
