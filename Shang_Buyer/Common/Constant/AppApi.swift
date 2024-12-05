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
    case getPopularShoes
    case addFav
    case getFavorite
    case removeFavorite(idFavorite: String)

    case getBrand
    case history
    case historyID(idHistory: String)

    case getDetailShoes(idShoes: String)
    case getReviews(idShoes: String)
    case getShoesClassification(idShoes: String)
    case getClassifications(idClassification: String)
    case getSizeClassification(idClassification: String)

    case bag
    case bagID(idBag: String)
    case fee
    case order
    case orderID(idOrder: String)
    case orderReturn(idOrder: String)

    case payments

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

        case .getPopularShoes:
            return "\(AppApi.baseURL)/api/customer/v2/statistical"

        case let .getDetailShoes(idShoes):
            if TokenManager.shared.getAccessToken() != nil {
                return "\(AppApi.baseURL)/api/customer/v1/shoes/\(idShoes)"
            } else {
                return "\(AppApi.baseURL)/api/customer/v2/shoes/\(idShoes)"
            }

        case let .getReviews(idShoes):
            return "\(AppApi.baseURL)/api/customer/v2/reviews/shoes/\(idShoes)"

        case .addFav:
            return "\(AppApi.baseURL)/api/customer/v1/favorites"

        case .getFavorite:
            return "\(AppApi.baseURL)/api/customer/v1/favorites"

        case let .removeFavorite(idFavorite):
            return "\(AppApi.baseURL)/api/customer/v1/favorites/\(idFavorite)"

            // MARK: Endpoint brand

        case .getBrand:
            return "\(AppApi.baseURL)/api/customer/v2/brands"

        case .history:
            return "\(AppApi.baseURL)/api/customer/v1/histories"

        case let .historyID(idHistory):
            return "\(AppApi.baseURL)/api/customer/v1/histories/\(idHistory)"

            // MARK: Endpoint Shoes Detail

        case let .getClassifications(idClassification):
            if TokenManager.shared.getAccessToken() != nil {
                return "\(AppApi.baseURL)/api/customer/v1/classifications/\(idClassification)"
            } else {
                return "\(AppApi.baseURL)/api/customer/v2/classifications/\(idClassification)"
            }

        case let .getShoesClassification(idShoes):
            return "\(AppApi.baseURL)/api/customer/v2/classifications/shoes/\(idShoes)"

        case let .getSizeClassification(idClassification):
            if TokenManager.shared.getAccessToken() != nil {
                return "\(AppApi.baseURL)/api/customer/v1/sizes/classification/\(idClassification)"
            } else {
                return "\(AppApi.baseURL)/api/customer/v2/sizes/classification/\(idClassification)"
            }

            // MARK: Endpoint Bag

        case .bag:
            return "\(AppApi.baseURL)/api/customer/v1/bags"

        case let .bagID(idBag):
            return "\(AppApi.baseURL)/api/customer/v1/bags/\(idBag)"

        case .fee:
            return "\(AppApi.baseURL)/api/customer/v1/orders/fee"

        case .order:
            return "\(AppApi.baseURL)/api/customer/v1/orders"

        case let .orderID(idOrder):
            return "\(AppApi.baseURL)/api/customer/v1/orders/\(idOrder)"

        case let .orderReturn(idOrder):
            return "\(AppApi.baseURL)/api/customer/v1/orders/return/\(idOrder)"

        case .payments:
            return "\(AppApi.baseURL)/api/customer/v1/payments"
        }
    }
}
