//
//  BagPatchResponse.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 22/11/2024.
//

import Foundation

struct BagPatchResponse: Codable {
    let status: String
    let message: String
    let data: BagData?
}
