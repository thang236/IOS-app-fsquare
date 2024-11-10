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

    case getDetailShoes(isLogin: Bool = false, idShoes: String)
    case getShoesClassification(idShoes: String)
    case getClassifications(idClassification: String)
    case getSizeClassification(idClassification: String)
    case getSize(idSize: String)

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

        case let .getDetailShoes(isLogin, idShoes):
            if isLogin {
                return "\(AppApi.baseURL)/api/customer/v1/shoes/\(idShoes)"
            } else {
                return "\(AppApi.baseURL)/api/customer/v2/shoes/\(idShoes)"
            }

        case let .getClassifications(idClassification):
            return "\(AppApi.baseURL)/api/customer/v2/classifications/\(idClassification)"

        case let .getShoesClassification(idShoes):
            return "\(AppApi.baseURL)/api/customer/v2/classifications/shoes/\(idShoes)"

        case let .getSizeClassification(idClassification):
            return "\(AppApi.baseURL)/api/customer/v2/sizes/classifications/{id}/\(idClassification)"

        case let .getSize(idSize):
            return "\(AppApi.baseURL)/api/customer/v2/sizes/\(idSize)"
        }
    }
}
