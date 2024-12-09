//
//  BrandResponse.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 11/10/2024.
//

import Foundation

struct BrandItem: Codable {
    let id: String
    let name: String
    let thumbnail: Thumbnail?
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case thumbnail
    }
}

struct BrandResponse: Codable {
    let status: String
    let message: String
    let data: [BrandItem]
    let options: Pagination
}
