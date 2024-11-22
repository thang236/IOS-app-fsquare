//
//  AddBagResponse.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 22/11/2024.
//

import Foundation

struct AddBagData: Codable {
    let id: String
    let customer: String?
    let size: String?
    let quantity: Int
    let createdAt: String?
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case customer
        case size
        case quantity
        case createdAt
        case updatedAt
    }
}

struct AddBagResponse: Codable {
    let status: String
    let message: String
    let data: AddBagData?
}
