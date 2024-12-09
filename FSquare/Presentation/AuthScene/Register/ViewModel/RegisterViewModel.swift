//
//  RegisterViewModel.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 25/09/2024.
//

import Combine
import Foundation

class RegisterViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var errorMessage: String? = nil
    @Published var checkAgree: Bool = false

    private let registerUseCase: RegisterUseCase
    private var cancellables = Set<AnyCancellable>()

    init(registerUseCase: RegisterUseCase) {
        self.registerUseCase = registerUseCase
    }

    func register(completion: @escaping (Result<AuthResponse, Error>) -> Void) {
        registerUseCase.execute(email: email)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { authResponse in
                completion(.success(authResponse))

            }).store(in: &cancellables)
    }
}
