//
//  LoginWithEmailViewModel.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 30/09/2024.
//

import Combine
import Foundation

class LoginWithEmailViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var errorMessage: String? = nil

    private let loginEmailUseCase: LoginEmailUseCase
    private var cancellables = Set<AnyCancellable>()

    init(loginEmailUseCase: LoginEmailUseCase) {
        self.loginEmailUseCase = loginEmailUseCase
    }

    func loginByEmail(completion: @escaping (Result<AuthResponse, Error>) -> Void) {
        loginEmailUseCase.execute(email: email)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    print(error)
                    self.errorMessage = error.localizedDescription
                }

            }, receiveValue: { authResponse in
                completion(.success(authResponse))
            }).store(in: &cancellables)
    }
}
