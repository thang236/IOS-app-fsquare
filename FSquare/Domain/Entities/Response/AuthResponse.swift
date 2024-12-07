//
//  AuthResponse.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 28/09/2024.
//

import Foundation

struct AuthResponse: Decodable {
    let status: String
    let message: String
    let data: String?
}
