//
//  SizesClassificationResponse.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 05/11/2024.
//

import Foundation

struct SizesClassificationData: Codable {
    let id: String
    let sizeNumber: String
    let weight: Double
    let quantity: Int
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case sizeNumber
        case weight
        case quantity
    }
}

struct SizesClassificationResponse: Codable {
    let status: String
    let message: String
    let data: [SizesClassificationData]?
}
