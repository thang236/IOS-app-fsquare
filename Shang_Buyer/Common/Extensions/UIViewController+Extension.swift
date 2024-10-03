//
//  UIViewController+Extension.swift
//  Shang
//
//  Created by Louis Macbook on 01/09/2024.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    func showAlertWithActions(title: String, message: String, okButtonTitle: String = "OK", cancelButtonTitle: String = "Cancel", okAction: (() -> Void)? = nil, cancelAction: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let ok = UIAlertAction(title: okButtonTitle, style: .default) { _ in
            okAction?()
        }
        let cancel = UIAlertAction(title: cancelButtonTitle, style: .cancel) { _ in
            cancelAction?()
        }
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    
    func showToast(message: String, chooseImageToast: ChooseImageToast) {
        let toastView = UIView()
        toastView.backgroundColor = UIColor.backgroundToast
        toastView.layer.cornerRadius = 10
        toastView.clipsToBounds = true
        toastView.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView()
        switch chooseImageToast {
        case .error:
            imageView.image = UIImage.Noti.notiError
        case .warning:
            imageView.image = UIImage.Noti.notiWarning
        case .success:
            imageView.image = UIImage.Noti.notiSuccess
        }
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        let toastLabel = UILabel()
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont.interItalicVariableFont(fontWeight: .regular, size: 14)
        toastLabel.text = message
        toastLabel.numberOfLines = 0
        toastLabel.textAlignment = .left
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [imageView, toastLabel])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        toastView.addSubview(stackView)
        
        self.view.addSubview(toastView)
        
        NSLayoutConstraint.activate([
               stackView.leadingAnchor.constraint(equalTo: toastView.leadingAnchor, constant: 10),
               stackView.trailingAnchor.constraint(equalTo: toastView.trailingAnchor, constant: -10),
               stackView.topAnchor.constraint(equalTo: toastView.topAnchor, constant: 10),
               stackView.bottomAnchor.constraint(equalTo: toastView.bottomAnchor, constant: -10),
               
               toastView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
               toastView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30),
               toastView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, constant: -40)
           ])
        
        // Animation cho toast
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastView.alpha = 0.0
        }, completion: { isCompleted in
            toastView.removeFromSuperview()
        })
    }




}
enum ChooseImageToast: String {
    case success
    case warning
    case error
}
