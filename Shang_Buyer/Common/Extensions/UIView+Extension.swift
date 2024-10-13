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

    func addShadow(
        shadowColor: UIColor = .black,
        shadowOpacity: Float = 0.5,
        shadowOffset: CGSize = CGSize(width: 0, height: 2),
        shadowRadius: CGFloat = 4.0
    ) {
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
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

    func roundBottomCorners(radius: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }

    func addShimmerEffect() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = [
            UIColor(white: 0.85, alpha: 1.0).cgColor,
            UIColor(white: 0.95, alpha: 1.0).cgColor,
            UIColor(white: 0.85, alpha: 1.0).cgColor,
        ]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.name = "shimmerLayer"
        layer.addSublayer(gradientLayer)

        // Thêm animation
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.duration = 0.9
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: "shimmerEffect")
    }

    // Hàm xoá shimmer effect
    func removeShimmerEffect() {
        layer.sublayers?.forEach { layer in
            if layer.name == "shimmerLayer" {
                layer.removeFromSuperlayer()
            }
        }
    }
}
