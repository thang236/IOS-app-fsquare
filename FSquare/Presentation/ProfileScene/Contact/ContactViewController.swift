//
//  ContactViewController.swift
//  FSquare
//
//  Created by Louis Macbook on 17/12/2024.
//

import UIKit

class ContactViewController: UIViewController {
    @IBOutlet var emailLabel: BodyLabel!
    @IBOutlet var locationLabel: BodyLabel!
    @IBOutlet var phoneLabel: BodyLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        let tapGestureEmail = UITapGestureRecognizer(target: self, action: #selector(labelDidGetTappedEmail))
        let tapGestureLocation = UITapGestureRecognizer(target: self, action: #selector(labelDidGetTappedLocation))
        let tapGesturePhone = UITapGestureRecognizer(target: self, action: #selector(labelDidGetTappedPhone))

        emailLabel.isUserInteractionEnabled = true
        locationLabel.isUserInteractionEnabled = true
        phoneLabel.isUserInteractionEnabled = true

        emailLabel.addGestureRecognizer(tapGestureEmail)
        locationLabel.addGestureRecognizer(tapGestureLocation)
        phoneLabel.addGestureRecognizer(tapGesturePhone)
    }

    @objc
    func labelDidGetTappedEmail(sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel else {
            return
        }
        UIPasteboard.general.string = label.text
        showToast(message: "Đã sao chép email", chooseImageToast: .success)
    }

    @objc
    func labelDidGetTappedPhone(sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel else {
            return
        }
        UIPasteboard.general.string = label.text
        showToast(message: "Đã sao chép số điện thoại", chooseImageToast: .success)
    }

    @objc
    func labelDidGetTappedLocation(sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel else {
            return
        }
        UIPasteboard.general.string = label.text
        showToast(message: "Đã sao chép địa chỉ", chooseImageToast: .success)
    }

    func setupNav() {
        navigationItem.hidesBackButton = true
        let image: UIImage = #imageLiteral(resourceName: "positionLeft")
        guard let size = navigationController?.navigationBar.frame.height else { return }
        let resizedImage = image.resizeImage(targetSize: CGSize(width: size, height: size))
        let backButton = UIBarButtonItem(image: resizedImage, style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .neutralUltraDark
        setupNavigationBar(leftBarButton: backButton, title: "Liên hệ", rightBarButton: nil)
    }

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
