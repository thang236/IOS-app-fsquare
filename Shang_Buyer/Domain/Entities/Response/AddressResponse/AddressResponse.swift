//
//  AddressResponse.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 10/11/2024.
//

import Foundation

struct AddressData: Codable {
    let id: String
    var title: String
    var address: String
    var wardName: String
    var districtName: String
    var provinceName: String
    var isDefault: Bool
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case address
        case wardName
        case provinceName
        case districtName
        case isDefault
    }
}

struct AddressResponse: Codable {
    let status: String
    let message: String
    let data: [AddressData]
}
