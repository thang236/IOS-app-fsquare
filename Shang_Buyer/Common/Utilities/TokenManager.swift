//
//  TokenManager.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 17/09/2024.
//

import Foundation

class TokenManager {
    static let shared = TokenManager()

    private let accessTokenKey = "accessToken"

    private init() {}

    func saveAccessToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: accessTokenKey)
    }

    func getAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: accessTokenKey)
    }

    func removeTokens() {
        UserDefaults.standard.removeObject(forKey: accessTokenKey)
    }
}
