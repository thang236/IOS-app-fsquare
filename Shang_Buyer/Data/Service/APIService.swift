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

    func request<T: Decodable, U: Encodable>(endpoint: AppApi, method: HTTPMethod, parameters: U?) -> AnyPublisher<T, Error>
}

class APIServiceImpl: APIService {
    private let session: Session

    init() {
        let interceptor = AuthInterceptor()
        session = Session(interceptor: interceptor)
    }

    func request<T: Decodable>(endpoint: AppApi, method: HTTPMethod, parameters: [String: Any]?) -> AnyPublisher<T, Error> {
        var encoding: ParameterEncoding = JSONEncoding.default
        if method == .get {
            encoding = URLEncoding.default
        } else {
            encoding = JSONEncoding.default
        }
        let url = endpoint.url
        return Future { promise in
            self.session.request(url, method: method, parameters: parameters, encoding: encoding)
                .validate()
                .responseData { response in
                    debugPrint("Response Data: \(String(data: response.data ?? Data(), encoding: .utf8) ?? "No data")")
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

    func request<T: Decodable, U: Encodable>(
        endpoint: AppApi,
        method: HTTPMethod,
        parameters: U? = nil
    ) -> AnyPublisher<T, Error> {
        var encoding: ParameterEncoding = JSONEncoding.default
        if method == .get {
            encoding = URLEncoding.default
        }

        let url = endpoint.url
        var paramDict: [String: Any]?

        if let parameters = parameters {
            do {
                let jsonData = try JSONEncoder().encode(parameters)
                paramDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
            } catch {
                return Fail(error: error).eraseToAnyPublisher()
            }
        }

        return Future { promise in
            self.session.request(url, method: method, parameters: paramDict, encoding: encoding)
                .validate()
                .responseData { response in
                    debugPrint("Response Data: \(String(data: response.data ?? Data(), encoding: .utf8) ?? "No data")")

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
