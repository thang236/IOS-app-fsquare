//
//  AddRemoveFavoriteResponse.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 16/11/2024.
//

import Foundation

struct AddFavoriteData: Codable, Hashable {
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

    static func == (lhs: AddFavoriteData, rhs: AddFavoriteData) -> Bool {
        return lhs.id == rhs.id
    }
}

struct AddFavoriteResponse: Codable {
    let status: String
    let message: String
    var data: AddFavoriteData
}

struct FavoriteRemoveResponse: Codable {
    let status: String
    let message: String
    var data: String
}
