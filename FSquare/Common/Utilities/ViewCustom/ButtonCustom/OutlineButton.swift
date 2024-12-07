//
//  OutlineButton.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 23/09/2024.
//

import Foundation
import UIKit

@IBDesignable
class OutlineButton: BaseButton {
    override func setup() {
        super.setup()
        addBorderAround(borderWidth: 1, borderColor: .primaryDark)
        tintColor = .primaryDark
        backgroundColor = .clear
    }

    override func updateButtonAppearance() {
        super.updateButtonAppearance()
        if isEnabled {
            addBorderAround(borderWidth: 1, borderColor: .primaryDark, cornerRadius: 8)
            tintColor = .primaryDark
        }
    }
}
