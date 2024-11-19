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
    case getAddress
    case getProvinces
    case getDistricts(idProvince: Int)
    case getWards(idDistrict: Int)
    case postLocation
    case editLocation(idLocation: String)
    case deleteLocation(idLocation: String)

    case getShoes
    case addFav

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

        case .getAddress:
            return "\(AppApi.baseURL)/api/customer/v1/customers/location"

        case .editProfile:
            return "\(AppApi.baseURL)/api/customer/v1/customers/profile"

        case .getProvinces:
            return "\(AppApi.baseURL)/api/customer/v1/locations/provinces"

        case let .getDistricts(idProvince):
            return "\(AppApi.baseURL)/api/customer/v1/locations/districts/\(idProvince)"

        case let .getWards(idDistrict):
            return "\(AppApi.baseURL)/api/customer/v1/locations/wards/\(idDistrict)"

        case .postLocation:
            return "\(AppApi.baseURL)/api/customer/v1/customers/location"

        case let .editLocation(idLocation):
            return "\(AppApi.baseURL)/api/customer/v1/customers/location/\(idLocation)"

        case let .deleteLocation(idLocation):
            return "\(AppApi.baseURL)/api/customer/v1/customers/location/\(idLocation)"

            // MARK: EndPoint Shoes

        case .getShoes:
            if TokenManager.shared.getAccessToken() != nil {
                return "\(AppApi.baseURL)/api/customer/v1/shoes"
            } else {
                return "\(AppApi.baseURL)/api/customer/v2/shoes"
            }

        case .addFav:
            return "\(AppApi.baseURL)/api/customer/v1/favorites"

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
