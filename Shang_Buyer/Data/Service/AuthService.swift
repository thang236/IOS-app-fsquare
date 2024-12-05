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
                    debugPrint("Response Auth Data: \(String(data: response.data ?? Data(), encoding: .utf8) ?? "No data")")

                    switch response.result {
                    case let .success(data):
                        do {
                            let decodedObject = try JSONDecoder().decode(T.self, from: data)
                            promise(.success(decodedObject))
                        } catch {
                            promise(.failure(error))
                        }
                    case let .failure(error):
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
