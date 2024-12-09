//
//  GhostButton.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 24/09/2024.
//

import Foundation
import UIKit

@IBDesignable
class GhostButton: BaseButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = UIColor.clear
        tintColor = UIColor.primaryDark
    }

    override func setup() {
        super.setup()
        backgroundColor = UIColor.clear
        tintColor = .primaryDark
    }

    override func updateButtonAppearance() {
        super.updateButtonAppearance()
        if isEnabled {
            backgroundColor = UIColor.clear
            tintColor = .primaryDark
        }
    }
}
