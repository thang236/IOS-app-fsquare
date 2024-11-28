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
        titleLabel?.font = UIFont.interItalicVariableFont(fontWeight: .medium, size: 16)?.withWeight(500)
        switch heightOption {
        case 0:
            titleLabel?.font = titleLabel?.font.withSize(16)
        case 1:
            titleLabel?.font = titleLabel?.font.withSize(14)
        case 2, 3:
            titleLabel?.font = titleLabel?.font.withSize(13)
        default:
            titleLabel?.font = UIFont.interItalicVariableFont(fontWeight: .regular, size: 16)?.withWeight(500)
        }
    }

    func setup() {
        DispatchQueue.main.async {
            self.layer.cornerRadius = 8
            self.clipsToBounds = true
            self.invalidateIntrinsicContentSize()
            self.addTarget(self, action: #selector(self.updateButtonAppearance), for: [.allTouchEvents, .allEvents])
            self.updateButtonAppearance()

            self.contentHorizontalAlignment = .center
            self.contentVerticalAlignment = .center
            self.titleLabel?.textAlignment = .center
        }
    }

    @objc func updateButtonAppearance() {
        if !isEnabled {
            backgroundColor = UIColor.backgroundLight
            tintColor = UIColor.borderDark
            layer.borderWidth = 0
        }
    }
}
