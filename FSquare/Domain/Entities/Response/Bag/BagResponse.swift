//
//  BagResponse.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 21/11/2024.
//

import Foundation

struct BagShoes: Codable {
    let id: String
    let name: String
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
    }
}

struct BagSize: Codable {
    let id: String
    let sizeNumber: String
    let weight: Double

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case sizeNumber
        case weight
    }
}

struct BagData: Codable, Hashable {
    let id: String
    let shoes: BagShoes?
    let thumbnail: Thumbnail?
    let color: String?
    let size: BagSize?
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

    static func == (lhs: BagData, rhs: BagData) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct BagResponse: Codable {
    let status: String
    let message: String
    var data: [BagData]?
}
