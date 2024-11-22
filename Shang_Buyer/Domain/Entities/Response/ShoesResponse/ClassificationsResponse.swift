//
//  ClassificationsResponse.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 04/11/2024.
//

import Foundation

struct ClassificationsData: Codable {
    let id: String
    let images: [Thumbnail]
    let color: String
    let country: String
    let price: Double
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case images
        case color
        case country
        case price
    }
}

struct ClassificationsResponse: Codable {
    let status: String
    let message: String
    let data: ClassificationsData
    let videos: Thumbnail?
}
