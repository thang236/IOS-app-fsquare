//
//  SizeResponse.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 05/11/2024.
//

import Foundation

struct SizeData: Codable {
    let id: String
    let sizeNumber: String
    let quantity: Double
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case sizeNumber
        case quantity
    }
}
