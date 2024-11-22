//
//  WardsResponse.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 10/11/2024.
//

import Foundation

struct WardsResponse: Codable {
    let status: String
    let message: String
    let data: [WardData]
}

struct WardData: Codable {
    let wardCode: String
    let wardName: String
}
