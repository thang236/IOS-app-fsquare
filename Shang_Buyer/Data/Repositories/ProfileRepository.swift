//
//  ProfileRepository.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 01/10/2024.
//

import Combine
import Foundation
import UIKit

protocol ProfileRepository {
    func getProfile() -> AnyPublisher<ProfileResponse, Error>
    func editProfile(parameters: [String: Any]) -> AnyPublisher<ProfileResponse, Error>
    func editAvatar(image: UIImage) -> AnyPublisher<ProfileResponse, Error>
}

class ProfileRepositoryImpl: ProfileRepository {
    private let apiService: APIService

    init(apiService: APIService) {
        self.apiService = apiService
    }

    func getProfile() -> AnyPublisher<ProfileResponse, Error> {
        apiService.request(endpoint: .getProfile, method: .get, parameters: nil)
    }

    func editProfile(parameters: [String: Any]) -> AnyPublisher<ProfileResponse, Error> {
        apiService.request(endpoint: .editProfile, method: .patch, parameters: parameters)
    }

    func editAvatar(image: UIImage) -> AnyPublisher<ProfileResponse, Error> {
        apiService.updateAvatar(avatarImage: image)
    }
}
