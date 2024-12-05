//
//  ReviewResponse.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 05/12/2024.
//

import Foundation

struct ReviewResponse: Codable {
    let status: String
    let message: String
    let data: [ReviewData?]
}

struct ReviewData: Codable, Hashable {
    let id: String
    let customer: Customer
    let rating: Double
    let content: String
    let images: [Thumbnail]?
    let videos: [Thumbnail]?
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case customer
        case rating
        case content
        case images
        case videos
        case createdAt
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: ReviewData, rhs: ReviewData) -> Bool {
        return lhs.id == rhs.id
    }
    
}

struct Customer: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let avatar: Thumbnail?
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstName
        case lastName
        case avatar
    }
}
