//
//  AppApi.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 12/09/2024.
//

import Foundation
import Alamofire

enum AppApi {
    static let baseURL = "http://localhost:3000"
    
    
    case getProductDetail(id: String)
    case getProduct
    
    var url: String {
        switch self {
        case .getProduct:
            return "\(AppApi.baseURL)/product"
        case let .getProductDetail(id):
            return "\(AppApi.baseURL)/product/\(id)"
        }
    }
}

