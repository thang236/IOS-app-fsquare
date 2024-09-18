//
//  AuthInterceptor.swift
//  TodoList_App
//
//  Created by Louis Macbook on 04/09/2024.
//

import Foundation
import UIKit

import Alamofire

class AuthInterceptor: RequestInterceptor {
    // Thêm Access Token vào mỗi request
    func adapt(_ urlRequest: URLRequest, for _: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest

        if let token = TokenManager.shared.getAccessToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        completion(.success(request))
    }

    // Xử lý khi gặp lỗi liên quan đến xác thực (401 Unauthorized)
    func retry(_ request: Request, for _: Session, dueTo _: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetry)
            return
        }

        // Thực hiện refresh token nếu gặp lỗi 401
        refreshAccessToken { success in
            if success {
                completion(.retry)
            } else {
                completion(.doNotRetry)
            }
        }
    }

    private func refreshAccessToken(completion: @escaping (Bool) -> Void) {
        guard let refreshToken = TokenManager.shared.getRefreshToken() else {
            completion(false)
            return
        }

        let refreshURL = "http://localhost:3000/auth/refresh"
        let parameters: [String: String] = ["refresh_token": refreshToken]

        AF.request(refreshURL, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                case let .success(data):
                    if let json = data as? [String: Any], let newAccessToken = json["access_token"] as? String {
                        TokenManager.shared.saveAccessToken(newAccessToken)
                        completion(true)
                    } else {
                        completion(false)
                    }
                case .failure:
                    completion(false)
                }
            }
    }
}
