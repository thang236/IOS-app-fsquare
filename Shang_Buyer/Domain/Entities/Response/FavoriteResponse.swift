//
//  FavoriteResponse.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 16/11/2024.
//

import Foundation

struct FavoriteData: Codable, Hashable {
    let id: String
    let customer: String
    let shoes: String
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case customer
        case shoes
        case createdAt
        case updatedAt
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
    var data: FavoriteData
}

struct FavoriteRemoveResponse: Codable {
    let status: String
    let message: String
    var data: String
}
