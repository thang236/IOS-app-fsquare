//
//  UIImageView+Extension.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 09/10/2024.
//

import Foundation
import Kingfisher
import UIKit

extension UIImageView {
    func startShimmerEffect() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.colors = [
            UIColor(white: 0.85, alpha: 1.0).cgColor,
            UIColor(white: 0.95, alpha: 1.0).cgColor,
            UIColor(white: 0.85, alpha: 1.0).cgColor,
        ]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        layer.addSublayer(gradientLayer)

        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.duration = 0.9
        animation.repeatCount = .infinity

        gradientLayer.add(animation, forKey: animation.keyPath)
    }

    func stopShimmerEffect() {
        if let sublayers = layer.sublayers {
            for layer in sublayers where layer is CAGradientLayer {
                layer.removeAllAnimations()
                layer.removeFromSuperlayer()
            }
        }
    }

    func loadImageWithShimmer(url: URL, placeholderImage: UIImage = UIImage.imageShimmer) {
        image = placeholderImage
        startShimmerEffect()

        kf.setImage(with: url, placeholder: placeholderImage) { result in
            switch result {
            case let .success(value):
                self.stopShimmerEffect() // Dừng shimmer khi ảnh đã tải xong
            case let .failure(error):
                print("Error loading image: \(error.localizedDescription)")
                self.self.stopShimmerEffect() // Dừng shimmer nếu tải ảnh thất bại
                self.image = placeholderImage // Giữ ảnh placeholder nếu tải ảnh thất bại
            }
        }
    }
}
