//
//  UIView+Extension.swift
//  Shang
//
//  Created by Louis Macbook on 01/09/2024.
//

import Foundation
import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    func addBorderAround(borderWidth: CGFloat, borderColor: UIColor, cornerRadius: CGFloat? = nil) {
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        if let cornerRadius = cornerRadius {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
    }

    func addTopBorder(color: UIColor, thickness: CGFloat) {
        let borderLayer = CALayer()
        borderLayer.name = "topBorder"
        borderLayer.backgroundColor = color.cgColor
        borderLayer.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: thickness)
        layer.addSublayer(borderLayer)
    }

    func addBottomBorder(color: UIColor, thickness: CGFloat) {
        let borderLayer = CALayer()
        borderLayer.name = "bottomBorder"
        borderLayer.backgroundColor = color.cgColor
        borderLayer.frame = CGRect(x: 0, y: frame.size.height - thickness, width: frame.size.width, height: thickness)
        layer.addSublayer(borderLayer)
    }
}
