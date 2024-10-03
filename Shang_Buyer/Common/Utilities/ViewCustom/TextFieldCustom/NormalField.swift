//
//  NormalField.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 25/09/2024.
//

import Foundation
import UIKit

@IBDesignable
class NormalField: BaseField {
    override func layoutSubviews() {
        super.layoutSubviews()
        textColor = .neutralGrayMedium
    }

    override func setup() {
        super.setup()
        addBorderAround(borderWidth: 1, borderColor: .borderMedium)
    }
}
