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

        // Giữ lại URL hiện tại để kiểm tra sau
        let currentURL = url

        kf.setImage(
            with: url,
            placeholder: placeholderImage,
            options: [.forceTransition, .fromMemoryCacheOrRefresh]
        ) { result in
            switch result {
            case let .success(value):
                // Kiểm tra xem URL hiện tại có khớp với URL đã tải hay không
                if currentURL == url {
                    self.stopShimmerEffect()
                    self.image = value.image
                } else {
                    // Nếu không khớp, bỏ qua việc gán hình ảnh
                    print("Error: Loaded image source does not match the expected source.")
                    self.stopShimmerEffect()
                }
            case let .failure(error):
                print("Error loading image: \(error.localizedDescription)")
                self.stopShimmerEffect()
                self.image = placeholderImage
            }
        }
    }
}
