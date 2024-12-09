//
//  PostReView.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 04/12/2024.
//

import Alamofire
import Foundation

struct RatingAPIService {
    static let shared = RatingAPIService()
    private init() {}

    func submitRating(
        orderID: String,
        rating: Float,
        content: String,
        files: [URL],
        completion: @escaping (Result<Data?, AFError>) -> Void
    ) {
        let url = "http://51.79.156.193:5000/api/customer/v1/reviews"
        let token = TokenManager.shared.getAccessToken()
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token ?? "")"]

        let parameters: [String: Any] = [
            "order": orderID,
            "rating": rating,
            "content": content,
        ]

        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    if let value = value as? String {
                        multipartFormData.append(value.data(using: .utf8)!, withName: key)
                    } else if let value = value as? Float {
                        multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                    }
                }

                for (index, fileURL) in files.prefix(5).enumerated() {
                    let fileName = "file\(index + 1)"
                    multipartFormData.append(fileURL, withName: "files", fileName: fileName, mimeType: fileURL.mimeType())
                }
            },
            to: url, method: .post, headers: headers
        ).response { response in
            debugPrint("Response Review Data: \(String(data: response.data ?? Data(), encoding: .utf8) ?? "No data")")

            switch response.result {
            case let .success(data):
                completion(.success(data))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
