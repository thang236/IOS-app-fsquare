//
//  HistoryResponse.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 05/12/2024.
//

import Foundation

struct HistoryData: Codable {
    let id: String
    let customer: String?
    let keyword: String
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case customer
        case keyword
        case createdAt
    }
}

struct HistoryResponse: Codable {
    let status: String
    let message: String
    var data: [HistoryData?]
}

struct PostHistoryResponse: Codable {
    let status: String
    let message: String
    var data: HistoryData?
}

struct DeleteHistoryResponse: Codable {
    let status: String
    let message: String
    let data: String?
}
