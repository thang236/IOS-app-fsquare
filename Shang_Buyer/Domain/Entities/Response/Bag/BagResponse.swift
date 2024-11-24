//
//  BagResponse.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 21/11/2024.
//

import Foundation

struct BagData: Codable {
    let id: String
    let shoes: String?
    let thumbnail: Thumbnail?
    let color: String?
    let size: String?
    var quantity: Int
    let price: Double

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case shoes
        case thumbnail
        case color
        case size
        case quantity
        case price
    }
}

struct BagResponse: Codable {
    let status: String
    let message: String
    var data: [BagData]?
}
