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
    
    var url: String {
        switch self {
        case .getProduct:
            return "123"
            //MARK: Endpoint auth
        case .signUp:
            return "\(AppApi.baseURL)/auth/customer/v1/registrations"
        case .verifyAuth:
            return "\(AppApi.baseURL)/auth/customer/v1/verifications"
        case .loginEmail:
            return "\(AppApi.baseURL)/auth/customer/v1/authentications"
            
            //MARK: Endpoint product
        case .getProfile:
            return "\(AppApi.baseURL)/api/customer/v1/customers/profile"
            
        }
    }
}
