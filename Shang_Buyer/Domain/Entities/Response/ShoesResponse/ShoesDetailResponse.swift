//
//  ShoesDetailResponse.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 31/10/2024.
//

import Foundation

struct shoesDetailData: Codable {
    let id: String
    let name: String
    let brand: String
    let category: String
    let describe: String
    let description: String
    let rating: Double
    let reviewCount: Int
    let isFavorite: Bool
    let thumbnail: Thumbnail

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case brand
        case category
        case describe
        case description
        case rating
        case reviewCount
        case isFavorite
        case thumbnail
    }
}

struct ShoesDetailResponse: Codable {
    let status: String
    let message: String
    let data: shoesDetailData
}
