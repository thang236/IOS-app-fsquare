//
//  AuthService.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 18/09/2024.
//

import Alamofire
import Combine
import Foundation

protocol AuthService {
    func request<T: Decodable>(endpoint: AppApi, parameters: [String: Any]?) -> AnyPublisher<T, Error>
}

class AuthServiceImpl: AuthService {
    func request<T>(endpoint: AppApi, parameters: [String: Any]?) -> AnyPublisher<T, Error> where T: Decodable {
        let url = endpoint.url
        
        return Future { promise in
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .validate()
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        do {
                            let decodedObject = try JSONDecoder().decode(T.self, from: data)
                            promise(.success(decodedObject))
                        } catch {
                            promise(.failure(error))
                        }
                    case .failure(let error):
                        if let data = response.data {
                            do {
                                let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                                let customError = NSError(domain: "", code: response.response?.statusCode ?? 0, userInfo: [NSLocalizedDescriptionKey: errorResponse.message])
                                promise(.failure(customError))
                            } catch {
                                promise(.failure(error))
                            }
                        } else {
                            promise(.failure(error))
                        }
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}

struct LoginResponse: Decodable {
    let token: String
}
