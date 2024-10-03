//
//  ErrorResponse.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 01/10/2024.
//

import Foundation

struct ErrorResponse: Decodable {
    let status: String
    let message: String
}
