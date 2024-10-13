//
//  APIService.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 17/09/2024.
//

import Alamofire
import Combine
import Foundation

protocol APIService {
    func request<T: Decodable>(endpoint: AppApi, method: HTTPMethod, parameters: [String: Any]?) -> AnyPublisher<T, Error>
    func requestNoToken<T: Decodable>(endpoint: AppApi, method: HTTPMethod, parameters: [String: Any]?) -> AnyPublisher<T, Error>
}

class APIServiceImpl: APIService {
    private let session: Session

    init() {
        let interceptor = AuthInterceptor()
        session = Session(interceptor: interceptor)
    }

    func request<T: Decodable>(endpoint: AppApi, method: HTTPMethod, parameters: [String: Any]?) -> AnyPublisher<T, Error> {
        let url = endpoint.url

        return Future { promise in
            self.session.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default)
                .validate()
                .responseData { response in

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

    func requestNoToken<T: Decodable>(endpoint: AppApi, method: HTTPMethod, parameters: [String: Any]?) -> AnyPublisher<T, Error> {
        let url = endpoint.url
        return Future { promise in
            AF.request(url, method: method, parameters: parameters, encoding: URLEncoding.default)
                .validate()
                .responseData { response in
                    switch response.result {
                    case let .success(data):
                        do {
                            let decodedObject = try JSONDecoder().decode(T.self, from: data)
                            promise(.success(decodedObject))
                        } catch {
                            print("error:  \(error)")
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
