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

struct ShoeData: Codable {
    let id: String
    let name: String
    let thumbnail: Thumbnail
    let minPrice: Double
    let maxPrice: Double
    let rating: Double
    let reviewCount: Int
    let isFavorite: Bool

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case thumbnail
        case minPrice
        case maxPrice
        case rating
        case reviewCount
        case isFavorite
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
    let data: [ShoeData]
    let options: Pagination
}
