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
        self.addBorderAround(borderWidth: 1, borderColor: .primaryDark)
        self.tintColor = .primaryDark
        self.backgroundColor = .clear
    }
    override func updateButtonAppearance() {
        super.updateButtonAppearance()
        if self.isEnabled {
            self.addBorderAround(borderWidth: 1, borderColor: .primaryDark, cornerRadius: 8)
            self.tintColor = .primaryDark
        }
    }
}
