//
//  ProfileViewModel.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 03/10/2024.
//

import Combine
import Foundation

class ProfileViewModel: ObservableObject {
    @Published var errorMessage: String = ""
    @Published var profileResponse: ProfileResponse?

    private var getProfileUseCase: GetProfileUseCase
    private var cancellables = Set<AnyCancellable>()

    init(getProfileUseCase: GetProfileUseCase) {
        self.getProfileUseCase = getProfileUseCase
    }

    func getProfile(completion: @escaping (Result<ProfileResponse, Error>) -> Void) {
        getProfileUseCase.execute().sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case let .failure(error):
                self.errorMessage = error.localizedDescription
            }
        }, receiveValue: { profileResponse in
            completion(.success(profileResponse))
        }).store(in: &cancellables)
    }
}
