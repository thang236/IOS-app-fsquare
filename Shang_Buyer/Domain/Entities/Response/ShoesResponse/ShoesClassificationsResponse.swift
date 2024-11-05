//
//  ShoesClassificationsResponse.swift
//  Shang_Buyer
//
//  Created by VinhLN on 04/11/2024.
//

import Foundation

struct ShoesClassificationsData: Codable {
    let id: String
    let thumbnail: Thumbnail
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case thumbnail
    }
}

struct ShoesClassificationsResponse: Codable {
    let status: String
    let message: String
    let data: [ShoesClassificationsData]
}
