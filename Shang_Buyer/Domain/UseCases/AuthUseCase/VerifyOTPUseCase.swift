//
//  VerifyOTPUseCase.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 27/09/2024.
//

import Combine
import Foundation

protocol VerifyOTPUseCase {
    func execute(parameter: [String: Any]) -> AnyPublisher<AuthResponse, Error>
}

class VerifyOTPUseCaseImpl: VerifyOTPUseCase {
    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(parameter: [String: Any]) -> AnyPublisher<AuthResponse, Error> {
        return authRepository.verifyOTPAuth(parameter: parameter)
    }
}
