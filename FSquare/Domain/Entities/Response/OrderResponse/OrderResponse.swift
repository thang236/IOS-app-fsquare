//
//  OrderResponse.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 27/11/2024.
//

import Foundation

struct OrderResponse: Codable {
    let status: String
    let message: String
    let data: OrderData?
}

struct OrderData: Codable, Hashable {
    let customer: String?
    let clientOrderCode: String
    let shippingAddress: ShippingAddress?
    let orderItems: [OrderItem]
    let weight: Double
    let codAmount: Double
    let shippingFee: Double
    let content: String
    let isFreeShip: Bool
    let isPayment: Bool
    let note: String?
    let status: String
    let statusTimestamps: StatusTimestamps?
    let returnInfo: ReturnInfo?
    let isActive: Bool?
    let id: String
    let createdAt: String?
    let updatedAt: String?
    let isReview: Bool?

    enum CodingKeys: String, CodingKey {
        case customer
        case clientOrderCode
        case shippingAddress
        case orderItems
        case weight
        case codAmount
        case shippingFee
        case content
        case isFreeShip
        case isPayment
        case note
        case status
        case statusTimestamps
        case returnInfo
        case isActive
        case id = "_id"
        case createdAt
        case updatedAt
        case isReview
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: OrderData, rhs: OrderData) -> Bool {
        return lhs.id == rhs.id
    }
}

struct OrderItem: Codable, Hashable {
    let size: String
    let shoes: String
    let quantity: Int
    let color: String?
    let thumbnail: Thumbnail?
    let price: Double
    let id: String?

    enum CodingKeys: String, CodingKey {
        case size
        case shoes
        case color
        case quantity
        case price
        case thumbnail
        case id = "_id"
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: OrderItem, rhs: OrderItem) -> Bool {
        return lhs.id == rhs.id
    }
}

struct StatusTimestamps: Codable {
    let pending: String?
    let processing: String?
    let shipped: String?
    let delivered: String?
    let confirmed: String?
    let cancelled: String?
    let returned: String?
}

struct ReturnInfo: Codable {
    let status: String
    let statusTimestamps: StatusReturnTimestamps?
}

struct StatusReturnTimestamps: Codable {
    let pending: String?
    let initiated: String?
    let completed: String?
    let refunded: String?
    let cancelled: String?
}
