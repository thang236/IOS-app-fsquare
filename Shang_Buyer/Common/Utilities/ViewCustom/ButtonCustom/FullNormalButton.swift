//
//  FullNormalButton.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 23/09/2024.
//

import Foundation
import UIKit

@IBDesignable
class FullNormalButton: BaseButton {
    override func setup() {
        super.setup()
        backgroundColor = .backgroundMedium
        tintColor = .neutralMedium
    }

    override func updateButtonAppearance() {
        super.updateButtonAppearance()
        if isEnabled {
            backgroundColor = .backgroundMedium
            tintColor = .neutralMedium
        }
    }
}
