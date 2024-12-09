//
//  OutlineNormalButton.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 23/09/2024.
//

import Foundation
import UIKit

@IBDesignable
class OutlineNormalButton: BaseButton {
    override func setup() {
        super.setup()
        addBorderAround(borderWidth: 1, borderColor: .borderLight)
        tintColor = .neutralGrayMedium
    }

    override func updateButtonAppearance() {
        super.updateButtonAppearance()
        if isEnabled {
            addBorderAround(borderWidth: 1, borderColor: .borderLight)
            tintColor = .neutralGrayMedium
        }
    }
}
