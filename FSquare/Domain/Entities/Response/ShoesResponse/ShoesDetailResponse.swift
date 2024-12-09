//
//  ShoesDetailResponse.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 31/10/2024.
//

import Foundation

struct ShoesDetailData: Codable, Hashable {
    let id: String
    let name: String
    let brand: String
    let category: String
    let describe: String
    let description: String?
    let classificationCount: Int
    let minPrice: Double
    let maxPrice: Double
    let rating: Double
    let reviewCount: Int
    var isFavorite: Bool?
    let thumbnail: Thumbnail?
    let sales: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case brand
        case category
        case describe
        case description
        case classificationCount
        case minPrice
        case maxPrice
        case rating
        case reviewCount
        case isFavorite
        case thumbnail
        case sales
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: ShoesDetailData, rhs: ShoesDetailData) -> Bool {
        return lhs.id == rhs.id
    }
}

struct ShoesDetailResponse: Codable {
    let status: String
    let message: String
    var data: ShoesDetailData?
}
