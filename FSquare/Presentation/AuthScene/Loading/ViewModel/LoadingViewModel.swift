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
    private let getAddressUseCase: GetAddressUseCase

    init(getProfileUseCase: GetProfileUseCase, getAddressUseCase: GetAddressUseCase) {
        self.getProfileUseCase = getProfileUseCase
        self.getAddressUseCase = getAddressUseCase
    }

    func getProfile(completion: @escaping (Result<ProfileResponse, Error>) -> Void) {
        getProfileUseCase.execute().sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                print("finished")
            case let .failure(error):
                self.errorMessage = error.localizedDescription
                TokenManager.shared.removeTokens()
            }
        }, receiveValue: { profileResponse in
            completion(.success(profileResponse))

            let nameUser = "\(profileResponse.data.firstName) \(profileResponse.data.lastName)"
            let phoneUser = profileResponse.data.phone

            UserDefaults.standard.set(nameUser, forKey: .nameUser)
            UserDefaults.standard.set(phoneUser, forKey: .phoneUser)
        }).store(in: &cancellables)
    }

    func getAddress() {
        getAddressUseCase.getAddress()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Completion: Success")
                case let .failure(failure):
                    self.errorMessage = failure.localizedDescription
                }
            } receiveValue: { address in
                if address.data.isEmpty {
                    UserDefaults.standard.set(false, forKey: .addressUser)
                } else {
                    UserDefaults.standard.set(true, forKey: .addressUser)
                }
            }
            .store(in: &cancellables)
    }
}
