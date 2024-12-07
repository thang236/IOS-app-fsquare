//
//  LoginEmailUseCase.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 30/09/2024.
//

import Combine
import Foundation

protocol LoginEmailUseCase {
    func execute(email: String) -> AnyPublisher<AuthResponse, Error>
}

class LoginEmailUseCaseImpl: LoginEmailUseCase {
    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    func execute(email: String) -> AnyPublisher<AuthResponse, Error> {
        return authRepository.loginEmail(email: email)
    }
}
