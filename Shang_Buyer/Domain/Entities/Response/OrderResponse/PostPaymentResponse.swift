//
//  PostPaymentResponse.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 29/11/2024.
//

import Foundation

struct PostPaymentData: Codable {
    let orderID: Int
    let redirectUrl: String
    let paymentUrl: String
}

struct PostPaymentResponse: Codable {
    let status: String
    let message: String
    let data: PostPaymentData?
}
