//
//  NotificationResponse.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 05/12/2024.
//

import Foundation
struct NotificationsResponse: Codable {
    let status: String
    let message: String
    let data: [NotificationData]
    let options: PaginationOptions
}

struct NotificationData: Codable {
    let id: String
    let order: String
    let title: String
    let content: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case order, title, content, createdAt
    }
}

struct PaginationOptions: Codable {
    let size: Int
    let page: Int
    let totalItems: Int
    let totalPages: Int
    let hasNextPage: Bool
    let hasPreviousPage: Bool
    let nextPage: Int?
    let prevPage: Int?
}
