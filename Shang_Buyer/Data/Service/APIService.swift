//
//  APIService.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 17/09/2024.
//

import Alamofire
import Combine

protocol APIService {
    func request<T: Decodable>(endpoint: AppApi, method: HTTPMethod, parameters: [String: Any]?) -> AnyPublisher<T, Error>
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
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case let .success(decodedObject):
                        promise(.success(decodedObject))
                    case let .failure(error):
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}
