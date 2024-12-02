//
//  OrderStatusResponse.swift
//  Shang_Buyer
//
//  Created by ThangHT on 29/11/2024.
//

import Foundation

struct OrderStatusResponse: Codable {
    let status: String
    let message: String
    let data: [OderStatusData?]?
}

struct OderStatusData: Codable {
    let id: String
    let clientOrderCode: String
    let codAmount: Double
    let shippingFee: Double
    let status: String
    let createdAt: String?
    let firstOrderItem: FirstOderItem?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case clientOrderCode
        case codAmount
        case shippingFee
        case status
        case createdAt
        case firstOrderItem
    }
}

struct FirstOderItem: Codable {
    let size: String
    let shoes: String
    let color: String
    let price: Double
    let quantity: Int
    let thumbnail: Thumbnail?
}
