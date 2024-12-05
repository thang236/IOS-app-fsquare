//
//  FavoriteResponse.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 20/11/2024.
//

import Foundation

struct FavoriteData: Codable, Hashable {
    let id: String
    let shoesId: String
    let name: String
    let minPrice: Double
    let maxPrice: Double
    let avgRating: Double
    let reviewCount: Int
    let thumbnail: Thumbnail?
    let sales: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case shoesId
        case name
        case minPrice
        case maxPrice
        case avgRating = "rating"
        case reviewCount
        case thumbnail
        case sales
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: FavoriteData, rhs: FavoriteData) -> Bool {
        return lhs.id == rhs.id
    }
}

struct FavoriteResponse: Codable {
    let status: String
    let message: String
    var data: [FavoriteData]
}
