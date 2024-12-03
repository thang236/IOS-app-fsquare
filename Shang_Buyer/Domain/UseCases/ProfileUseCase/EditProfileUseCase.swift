//
//  EditProfileUseCase.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 04/10/2024.
//

import Combine
import Foundation
import UIKit

protocol EditProfileUseCase {
    func execute(parameter: [String: Any]) -> AnyPublisher<ProfileResponse, Error>
    func editAvatar(image: UIImage) -> AnyPublisher<ProfileResponse, Error>
}

class EditProfileUseCaseImpl: EditProfileUseCase {
    private let profileRepository: ProfileRepository

    init(profileRepository: ProfileRepository) {
        self.profileRepository = profileRepository
    }

    func execute(parameter: [String: Any]) -> AnyPublisher<ProfileResponse, Error> {
        profileRepository.editProfile(parameters: parameter)
    }

    func editAvatar(image: UIImage) -> AnyPublisher<ProfileResponse, Error> {
        profileRepository.editAvatar(image: image)
    }
}
