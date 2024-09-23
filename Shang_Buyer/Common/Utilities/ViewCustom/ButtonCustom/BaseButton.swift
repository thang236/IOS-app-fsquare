//
//  BaseButton.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 23/09/2024.
//

import Foundation
import UIKit

class BaseButton: UIButton {
    @IBInspectable var heightOption: Int = 1 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    private var buttonHeight: CGFloat {
        let allHeights = ButtonHeight.allCases
        guard heightOption >= 0 && heightOption < allHeights.count else {
            return ButtonHeight.medium.rawValue
        }
        return allHeights[heightOption].rawValue
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: frame.size.width, height: buttonHeight)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.font = UIFont.interItalicVariableFont(fontWeight: .regular, size: 16)?.withWeight(500)
    }

    func setup() {
        layer.cornerRadius = 8
        clipsToBounds = true
        invalidateIntrinsicContentSize()
        addTarget(self, action: #selector(updateButtonAppearance), for: [.allTouchEvents, .allEvents])
        updateButtonAppearance()
    }

    @objc func updateButtonAppearance() {
        if !isEnabled {
            backgroundColor = UIColor.backgroundLight
            tintColor = UIColor.borderDark
            layer.borderWidth = 0
        }
    }
}
