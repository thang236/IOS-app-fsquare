//
//  FeeResponse.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 26/11/2024.
//

import Foundation

struct FeeResponse: Codable {
    let status: String
    let message: String
    let data: Double?
}
