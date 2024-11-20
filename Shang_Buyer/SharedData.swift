//
//  SharedData.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 20/11/2024.
//

import Foundation

class SharedData: ObservableObject {
    static let shared = SharedData()
    @Published var idShoesRemoveFav: String? = nil
}
