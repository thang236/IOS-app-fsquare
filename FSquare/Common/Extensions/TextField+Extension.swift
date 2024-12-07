//
//  TextField+Extension.swift
//  Shang
//
//  Created by Louis Macbook on 01/09/2024.
//

import Foundation
import UIKit

extension UITextField {
    @IBInspectable var rightImage: UIImage? {
        get {
            if let imageView = rightView as? UIImageView {
                return imageView.image
            }
            return nil
        }
        set {
            guard let image = newValue else { return }
            setRightIcon(image)
        }
    }

    @IBInspectable var rightImageSize: CGSize {
        get {
            return CGSize(width: rightView?.frame.width ?? 24, height: rightView?.frame.height ?? 24)
        }
        set {
            if let imageView = rightView as? UIImageView {
                let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue.width + 10, height: newValue.height))
                imageView.frame = CGRect(x: 0, y: 0, width: newValue.width, height: newValue.height)
                paddingView.addSubview(imageView)
                rightView = paddingView
            }
        }
    }

    func addIconToLeft(image: UIImage, padding: CGFloat) {
        let iconView = UIImageView(frame: CGRect(x: 0, y: 0, width: image.size.width + padding, height: image.size.height))
        iconView.image = image
        iconView.contentMode = .center

        let iconContainerView = UIView(frame: CGRect(x: 0, y: 0, width: image.size.width + padding, height: image.size.height))
        iconContainerView.addSubview(iconView)

        leftView = iconContainerView
        leftViewMode = .always
    }

    func setRightIcon(_ image: UIImage?, withSize size: CGSize = CGSize(width: 24, height: 24)) {
        guard let image = image else { return }

        let iconImageView = UIImageView(image: image)
        iconImageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .neutralDark

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: size.width + 10, height: size.height)) // Thêm 10px padding
        paddingView.addSubview(iconImageView)

        rightView = paddingView
        rightViewMode = .always
    }

    func addRightButton(image: UIImage, target: Any, action: Selector) {
        let rightButton = UIButton(type: .system)
        rightButton.setImage(image, for: .normal)
        rightButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)

        rightButton.addTarget(target, action: action, for: .touchUpInside)

        rightView = rightButton
        rightViewMode = .always
    }
}
