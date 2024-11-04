//
//  AppApi.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 12/09/2024.
//

import Alamofire
import Foundation

enum AppApi {
    static let baseURL = "http://51.79.156.193:5000"
    case signUp
    case verifyAuth
    case getProduct
    case loginEmail

    case getProfile
    case editProfile

    case getShoes

    case getBrand

    case getDetailShoes(id: String)
    case getShoesClassification(id: String)
    case getClassifications(id: String)

    var url: String {
        switch self {
        case .getProduct:
            return "123"

            // MARK: Endpoint auth

        case .signUp:
            return "\(AppApi.baseURL)/auth/customer/v1/registrations"

        case .verifyAuth:
            return "\(AppApi.baseURL)/auth/customer/v1/verifications"

        case .loginEmail:
            return "\(AppApi.baseURL)/auth/customer/v1/authentications"

            // MARK: Endpoint profile

        case .getProfile:
            return "\(AppApi.baseURL)/api/customer/v1/customers/profile"

        case .editProfile:
            return "\(AppApi.baseURL)/api/customer/v1/customers/profile"

            // MARK: EndPoint Shoes

        case .getShoes:
            return "\(AppApi.baseURL)/api/customer/v2/shoes"

            // MARK: Endpoint brand

        case .getBrand:
            return "\(AppApi.baseURL)/api/customer/v2/brands"

            // MARK: Endpoint Shoes Detail

        case let .getDetailShoes(id):
            return "\(AppApi.baseURL)/api/customer/v2/shoes/\(id)"

        case let .getClassifications(id):
            return "\(AppApi.baseURL)/api/customer/v2/classifications/\(id)"

        case let .getShoesClassification(id):
            return "\(AppApi.baseURL)/api/customer/v2/classifications/shoes/\(id)"
        }
    }
}
