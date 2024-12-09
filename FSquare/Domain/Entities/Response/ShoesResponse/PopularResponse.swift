//
//  PopularResponse.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 05/12/2024.
//

import Foundation

struct PopularData: Codable {
    let id: String
    let name: String
    let totalSales: Int
    let totalRevenue: Double
    let thumbnail: Thumbnail?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case totalSales
        case totalRevenue
        case thumbnail
    }
}

struct PopularResponse: Codable {
    let status: String
    let message: String
    let data: [PopularData]
}
