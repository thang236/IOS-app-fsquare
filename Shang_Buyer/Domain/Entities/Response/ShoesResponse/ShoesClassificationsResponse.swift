//
//  ShoesClassificationsResponse.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 04/11/2024.
//

import Foundation

struct ShoesClassificationsData: Codable, Hashable {
    let id: String
    let thumbnail: Thumbnail
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case thumbnail
    }

    static func == (lhs: ShoesClassificationsData, rhs: ShoesClassificationsData) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct ShoesClassificationsResponse: Codable {
    let status: String
    let message: String
    let data: [ShoesClassificationsData]
}
