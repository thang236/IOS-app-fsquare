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
    var data: [OderStatusData?]?
}

struct OderStatusData: Codable {
    let id: String
    let clientOrderCode: String
    let codAmount: Double
    let shippingFee: Double
    let status: String
    let createdAt: String?
    let firstOrderItem: FirstOderItem?
    let totalQuantity: Int?
    let productSamplesCount: Int?
    let isReview: Bool?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case clientOrderCode
        case codAmount
        case shippingFee
        case status
        case createdAt
        case firstOrderItem
        case totalQuantity
        case productSamplesCount
        case isReview
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

extension OderStatusData {
    init(from orderData: OrderData) {
        id = orderData.id
        clientOrderCode = orderData.clientOrderCode
        codAmount = orderData.codAmount
        shippingFee = orderData.shippingFee
        status = orderData.status
        createdAt = orderData.createdAt
        isReview = orderData.isReview

        if let firstItem = orderData.orderItems.first {
            firstOrderItem = FirstOderItem(
                size: firstItem.size,
                shoes: firstItem.shoes,
                color: firstItem.color ?? "",
                price: firstItem.price,
                quantity: firstItem.quantity,
                thumbnail: firstItem.thumbnail
            )
        } else {
            firstOrderItem = nil
        }

        totalQuantity = orderData.orderItems.reduce(0) { $0 + $1.quantity }

        productSamplesCount = orderData.orderItems.count
    }
}
