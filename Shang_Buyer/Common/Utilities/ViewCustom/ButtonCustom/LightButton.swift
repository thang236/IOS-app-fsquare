//
//  LightButton.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 23/09/2024.
//

import Foundation
import UIKit

@IBDesignable
class LightButton: BaseButton {
    override func setup() {
        super.setup()
        backgroundColor = .backgroundDark
        tintColor = .neutralGrayMedium
    }

    override func updateButtonAppearance() {
        super.updateButtonAppearance()
        if isEnabled {
            backgroundColor = .backgroundDark
            tintColor = .neutralGrayMedium
        }
    }
}
