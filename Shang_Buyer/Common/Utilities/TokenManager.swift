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
    private let refreshTokenKey = "refreshToken"

    private init() {}

    // Lưu Access Token
    func saveAccessToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: accessTokenKey)
    }

    // Lưu Refresh Token
    func saveRefreshToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: refreshTokenKey)
    }

    // Lấy Access Token
    func getAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: accessTokenKey)
    }

    // Lấy Refresh Token
    func getRefreshToken() -> String? {
        return UserDefaults.standard.string(forKey: refreshTokenKey)
    }

    // Xóa token khi người dùng đăng xuất hoặc khi token hết hạn
    func removeTokens() {
        UserDefaults.standard.removeObject(forKey: accessTokenKey)
        UserDefaults.standard.removeObject(forKey: refreshTokenKey)
    }
}

