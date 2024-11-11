//
//  DistrictsResponse.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 10/11/2024.
//

import Foundation

struct DistrictsResponse: Codable {
    let status: String
    let message: String
    let data: [DistrictData]
}

struct DistrictData: Codable {
    let districtID: Int
    let districtName: String
}
