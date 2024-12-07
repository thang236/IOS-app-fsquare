//
//  ShoesResponse.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 09/10/2024.
//

import Foundation

struct Thumbnail: Codable {
    let url: String
}

struct ShoeData: Codable, Hashable {
    let id: String
    let name: String
    let thumbnail: Thumbnail?
    let minPrice: Double
    let maxPrice: Double
    let rating: Double
    let reviewCount: Int
    var isFavorite: Bool?
    let sales: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case thumbnail
        case minPrice
        case maxPrice
        case rating
        case reviewCount
        case isFavorite
        case sales
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: ShoeData, rhs: ShoeData) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Pagination: Codable {
    let size: Int
    let page: Int
    let totalItems: Int
    let hasNextPage: Bool
    let hasPreviousPage: Bool
    let nextPage: Int?
    let prevPage: Int?
}

struct ShoesResponse: Codable {
    let status: String
    let message: String
    var data: [ShoeData]
    let options: Pagination
}
