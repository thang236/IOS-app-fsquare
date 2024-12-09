//
//  ProvincesResponse.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 10/11/2024.
//

import Foundation

struct ProvincesResponse: Codable {
    let status: String
    let message: String
    let data: [ProvinceData]
}

struct ProvinceData: Codable {
    let provinceID: Int
    let provinceName: String
}
