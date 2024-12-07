//
//  UIFont+Extension.swift
//  Shang
//
//  Created by Louis Macbook on 05/09/2024.
//

import Foundation
import UIKit

extension UIFont {
    static func interItalicVariableFont(fontWeight: FontWeight, size: CGFloat) -> UIFont? {
        return UIFont(name: fontWeight.rawValue, size: size)
    }

    func withWeight(_ weight: CGFloat) -> UIFont {
        let fontDescriptor = self.fontDescriptor.addingAttributes([.traits: [UIFontDescriptor.TraitKey.weight: weight]])
        return UIFont(descriptor: fontDescriptor, size: pointSize)
    }
}
