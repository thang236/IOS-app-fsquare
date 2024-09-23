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
        self.backgroundColor = .backgroundMedium
        self.tintColor = .neutralMedium
    }
    
    override func updateButtonAppearance() {
        super.updateButtonAppearance()
        if self.isEnabled {
            self.backgroundColor = .backgroundMedium
            self.tintColor = .neutralMedium
        }
    }
}
