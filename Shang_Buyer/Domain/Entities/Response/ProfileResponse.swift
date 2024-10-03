//
//  ProfileResponse.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 01/10/2024.
//

import Foundation

struct ProfileItem: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let avatar: String?
    let birthDay: String?
    let phone: String?
    let address: String?
    let longitude: Double?
    let latitude: Double?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstName
        case lastName
        case email
        case avatar
        case birthDay
        case phone
        case address
        case longitude
        case latitude
    }
}

struct ProfileResponse: Codable {
    let status: String
    let message: String
    let data: ProfileItem
}
