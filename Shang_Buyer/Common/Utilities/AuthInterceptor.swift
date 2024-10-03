//
//  AuthInterceptor.swift
//  TodoList_App
//
//  Created by Louis Macbook on 04/09/2024.
//

import Alamofire
import Foundation
import UIKit

class AuthInterceptor: RequestInterceptor {
    // Thêm Access Token và Content-Type vào mỗi request
    func adapt(_ urlRequest: URLRequest, for _: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest

        // Thêm Access Token
        if let token = TokenManager.shared.getAccessToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            let error = NSError(domain: "AuthInterceptor", code: 401, userInfo: [NSLocalizedDescriptionKey: "No Access Token available."])
            completion(.failure(error))
            return
        }

        // Thêm Content-Type
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // Thay đổi giá trị nếu cần

        completion(.success(request))
    }
}
