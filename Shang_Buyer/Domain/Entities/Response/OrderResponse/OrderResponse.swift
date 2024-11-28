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
    let data: OrderData
}

struct OrderData: Codable {
    let customer: String
    let clientOrderCode: String
    let shippingAddress: ShippingAddress
    let orderItems: [OrderItem]
    let weight: Int
    let codAmount: Int
    let shippingFee: Int
    let content: String
    let isFreeShip: Bool
    let isPayment: Bool
    let note: String
    let status: String
    let statusTimestamps: StatusTimestamps
    let returnInfo: ReturnInfo
    let isActive: Bool
    let id: String
    let createdAt: String
    let updatedAt: String

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
    }
}


struct OrderItem: Codable {
    let size: String
    let shoes: String
    let quantity: Int
    let price: Double
    let id: String?

    enum CodingKeys: String, CodingKey {
        case size
        case shoes
        case quantity
        case price
        case id = "_id"
    }
}

struct StatusTimestamps: Codable {
    let pending: String
}

struct ReturnInfo: Codable {
    let status: String
}
