//
//  ProfileViewModel.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 03/10/2024.
//

import Combine
import Foundation
import UIKit

class ProfileViewModel: ObservableObject {
    @Published var errorMessage: String? = nil
    @Published var profileResponse: ProfileResponse?

    private var getProfileUseCase: GetProfileUseCase
    private var cancellables = Set<AnyCancellable>()
    private let editProfileUseCase: EditProfileUseCase

    init(getProfileUseCase: GetProfileUseCase, editProfileUseCase: EditProfileUseCase) {
        self.getProfileUseCase = getProfileUseCase
        self.editProfileUseCase = editProfileUseCase
    }

    func getProfile(completion: @escaping (Result<ProfileResponse, Error>) -> Void) {
        getProfileUseCase.execute().sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case let .failure(error):
                if let error = error as? NSError {
                    if error.code == 401 {
                    } else {
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
        }, receiveValue: { profileResponse in
            completion(.success(profileResponse))
        }).store(in: &cancellables)
    }

    func updateProfile(avartar: UIImage, completion: @escaping (Result<ProfileResponse, Error>) -> Void) {
        editProfileUseCase.editAvatar(image: avartar)
            .sink(receiveCompletion: { result in
                print("Completion: \(result)")
                switch result {
                case .finished:
                    break
                case let .failure(failure):
                    self.errorMessage = failure.localizedDescription
                }
            }, receiveValue: { response in
                print("response:  \(response)")
                completion(.success(response))

            }).store(in: &cancellables)
    }
}
