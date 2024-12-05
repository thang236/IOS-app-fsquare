//
//  OrderRequest.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 27/11/2024.
//

import Foundation

struct OrderRequest: Codable {
    let order: Order
    let orderItems: [OrderItem]
}

struct Order: Codable {
    let clientOrderCode: String
    let shippingAddress: ShippingAddress
    let weight: Double
    let codAmount: Double
    let shippingFee: Double
    let content: String
    let isFreeShip: Bool
    let isPayment: Bool
    let note: String
}

struct ShippingAddress: Codable {
    let toName: String
    let toAddress: String
    let toProvinceName: String
    let toDistrictName: String
    let toWardName: String
    let toPhone: String
}
