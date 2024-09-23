//
//  AuthService.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 18/09/2024.
//

import Alamofire
import Combine

protocol AuthService {
    func login(username: String, password: String) -> AnyPublisher<String, Error>
}

class AuthServiceImpl: AuthService {
    func login(username: String, password: String) -> AnyPublisher<String, Error> {
        let loginURL = "https://api.example.com/login"
        let parameters: [String: String] = ["username": username, "password": password]

        return Future { promise in
            AF.request(loginURL, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .validate()
                .responseDecodable(of: LoginResponse.self) { response in
                    switch response.result {
                    case let .success(loginResponse):
                        TokenManager.shared.saveAccessToken(loginResponse.token)
                        promise(.success(loginResponse.token))
                    case let .failure(error):
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}

// Define your response model
struct LoginResponse: Decodable {
    let token: String
}
