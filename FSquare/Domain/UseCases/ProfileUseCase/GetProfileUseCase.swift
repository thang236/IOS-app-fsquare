//
//  GetProfileUseCase.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 01/10/2024.
//

import Combine
import Foundation

protocol GetProfileUseCase {
    func execute() -> AnyPublisher<ProfileResponse, Error>
}

class GetProfileUseCaseImpl: GetProfileUseCase {
    private let profileRepository: ProfileRepository

    init(profileRepository: ProfileRepository) {
        self.profileRepository = profileRepository
    }

    func execute() -> AnyPublisher<ProfileResponse, Error> {
        return profileRepository.getProfile()
    }
}
