//
//  PaddingLabel.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 01/12/2024.
//

import Foundation
import UIKit

@IBDesignable class PaddingLabel: UILabel {
    @IBInspectable var topPadding: CGFloat = 0.0
    @IBInspectable var leftPadding: CGFloat = 0.0
    @IBInspectable var bottomPadding: CGFloat = 0.0
    @IBInspectable var rightPadding: CGFloat = 0.0

    // Khởi tạo với UIEdgeInsets
    convenience init(padding: UIEdgeInsets) {
        self.init()
        DispatchQueue.main.async {
            self.topPadding = padding.top
            self.leftPadding = padding.left
            self.bottomPadding = padding.bottom
            self.rightPadding = padding.right
        }
    }

    private func setupStyle() {
        if let interFont = UIFont.interItalicVariableFont(fontWeight: .medium, size: font.pointSize) {
            font = interFont.withWeight(500)
        } else {
            font = UIFont.systemFont(ofSize: font.pointSize, weight: .semibold)
        }
    }

    override func drawText(in rect: CGRect) {
        setupStyle()
        let padding = UIEdgeInsets(top: topPadding, left: leftPadding, bottom: bottomPadding, right: rightPadding)
        let paddedRect = rect.inset(by: padding)
        super.drawText(in: paddedRect)
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.width += leftPadding + rightPadding
        contentSize.height += topPadding + bottomPadding
        return contentSize
    }
}
