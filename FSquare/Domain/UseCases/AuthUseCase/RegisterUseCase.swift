//
//  RegisterUseCase.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 25/09/2024.
//

import Combine
import Foundation

protocol RegisterUseCase {
    func execute(email: String) -> AnyPublisher<AuthResponse, Error>
}

class RegisterUseCaseImpl: RegisterUseCase {
    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    func execute(email: String) -> AnyPublisher<AuthResponse, Error> {
        return authRepository.signUp(email: email)
    }
}
