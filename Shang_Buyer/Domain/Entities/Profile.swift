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
        Profile(icon: UIImage.user, title: "Edit Profile"),
        Profile(icon: UIImage.mappin, title: "Address"),
        Profile(icon: UIImage.bell, title: "Notification"),
        Profile(icon: UIImage.myWallete, title: "My Wallete"),
        Profile(icon: UIImage.shield, title: "Security"),
        Profile(icon: UIImage.lockFix, title: "Privacy  Policy"),
        Profile(icon: UIImage.loginLogout, title: "Logout"),
    ]
}

enum SettingProfileTable: Int {
    case editProfile = 0
    case address = 1
    case noti = 2
    case wallet = 3
    case security = 4
    case policy = 5
    case logout = 6
}
