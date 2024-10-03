//
//  AuthRepository.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 25/09/2024.
//

import Combine
import Foundation

protocol AuthRepository {
    func signUp(email: String) -> AnyPublisher<AuthResponse, Error>
    func verifyOTPAuth(parameter: [String: Any]) -> AnyPublisher<AuthResponse, Error>
    func loginEmail(email: String) -> AnyPublisher<AuthResponse, Error>
}

class AuthRepositoryImpl: AuthRepository {
    private let authService: AuthService

    init(authService: AuthService) {
        self.authService = authService
    }

    func loginEmail(email: String) -> AnyPublisher<AuthResponse, Error> {
        let parameter = ["email": email]
        return authService.request(endpoint: .loginEmail, parameters: parameter)
    }

    func verifyOTPAuth(parameter: [String: Any]) -> AnyPublisher<AuthResponse, Error> {
        return authService.request(endpoint: .verifyAuth, parameters: parameter)
    }

    func signUp(email: String) -> AnyPublisher<AuthResponse, Error> {
        let parameters = ["email": email]
        return authService.request(endpoint: .signUp, parameters: parameters)
    }
}
