//
//  Profile.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 03/10/2024.
//

import Foundation
import UIKit

struct Profile {
    let icon: UIImage
    let title: String
}

extension Profile {
    static var profiles: [Profile] {
        var profiles: [Profile] = [
            Profile(icon: UIImage.user, title: "Chỉnh sửa hồ sơ"),
            Profile(icon: UIImage.mappin, title: "Địa chỉ"),
            Profile(icon: UIImage.bell, title: "Thông báo"),
            Profile(icon: UIImage.lockFix, title: "Chính sách quyền riêng tư"),
            Profile(icon: UIImage(systemName: "phone.bubble") ?? UIImage.bell, title: "Liên hệ"),
        ]
        let loginLogoutProfile = TokenManager.shared.getAccessToken() != nil
            ? Profile(icon: UIImage.loginLogout, title: "Đăng xuất")
            : Profile(icon: UIImage.loginLogout, title: "Đăng nhập")
        profiles.append(loginLogoutProfile)
        return profiles
    }
}

enum SettingProfileTable: Int {
    case editProfile = 0
    case address = 1
    case noti = 2
    case policy = 3
    case contact = 4
    case logout = 5
}
