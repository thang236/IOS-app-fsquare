//
//  LoadingViewModel.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 01/10/2024.
//

import Combine
import Foundation

class LoadingViewModel: ObservableObject {
    @Published var checkToken: Bool = false
    @Published var errorMessage: String? = nil

    private var getProfileUseCase: GetProfileUseCase
    private var cancellables = Set<AnyCancellable>()

    init(getProfileUseCase: GetProfileUseCase) {
        self.getProfileUseCase = getProfileUseCase
    }

    func getProfile(completion: @escaping (Result<ProfileResponse, Error>) -> Void) {
        getProfileUseCase.execute().sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                print("finished")
            case let .failure(error):
                self.errorMessage = error.localizedDescription
            }
        }, receiveValue: { profileResponse in
            let nameUser = "\(profileResponse.data.firstName) \(profileResponse.data.lastName)"
            let phoneUser = profileResponse.data.phone

            UserDefaults.standard.set(nameUser, forKey: .nameUser)
            UserDefaults.standard.set(phoneUser, forKey: .phoneUser)
            completion(.success(profileResponse))
        }).store(in: &cancellables)
    }
}
