//
//  BaseField.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 25/09/2024.
//

import Foundation
import UIKit

class BaseField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: frame.size.width, height: 48)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        font = UIFont.interItalicVariableFont(fontWeight: .regular, size: 14)?.withWeight(400)
    }

    func setup() {
        layer.masksToBounds = true
        layer.cornerRadius = 8
        backgroundColor = .backgroundLight
    }
}
