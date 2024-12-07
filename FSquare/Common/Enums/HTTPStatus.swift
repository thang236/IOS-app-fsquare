//
//  HTTPStatus.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 30/09/2024.
//

import Foundation

enum HTTPStatus: Int {
    case success = 200
    case created = 201
    case noContent = 204
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case requestTimeout = 408
    case conflict = 409
    case internalServerError = 500
    case serviceUnavailable = 503

    var message: String {
        switch self {
        case .success:
            return "Success"
        case .created:
            return "Created"
        case .noContent:
            return "No Content"
        case .badRequest:
            return "Bad Request"
        case .unauthorized:
            return "Unauthorized"
        case .forbidden:
            return "Forbidden"
        case .notFound:
            return "Not Found"
        case .requestTimeout:
            return "Request Timeout"
        case .conflict:
            return "Conflict"
        case .internalServerError:
            return "Internal Server Error"
        case .serviceUnavailable:
            return "Service Unavailable"
        }
    }
}
