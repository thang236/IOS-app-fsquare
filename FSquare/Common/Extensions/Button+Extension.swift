//
//  Button+Extension.swift
//  Shang
//
//  Created by Louis Macbook on 01/09/2024.
//

import Foundation
import UIKit

extension UIButton {
    func applyOutletButton(cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        clipsToBounds = true
    }
}
