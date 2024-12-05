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
    static let profiles: [Profile] = [
        Profile(icon: UIImage.user, title: "Chỉnh sửa hồ sơ"),
        Profile(icon: UIImage.mappin, title: "Địa chỉ"),
        Profile(icon: UIImage.bell, title: "Thông báo"),
        Profile(icon: UIImage.lockFix, title: "Chính sách quyền riêng tư"),
        Profile(icon: UIImage.loginLogout, title: "Đăng xuất"),
    ]
}

enum SettingProfileTable: Int {
    case editProfile = 0
    case address = 1
    case noti = 2
    case policy = 3
    case logout = 4
}
