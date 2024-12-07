//
//  HeadingLabel.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 20/09/2024.
//

import UIKit

class HeadingLabel: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupStyle()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }

    private func setupStyle() {
        if let interFont = UIFont.interItalicVariableFont(fontWeight: .semibold, size: font.pointSize) {
            font = interFont.withWeight(600)
        } else {
            font = UIFont.systemFont(ofSize: font.pointSize, weight: .semibold)
        }
    }
}
