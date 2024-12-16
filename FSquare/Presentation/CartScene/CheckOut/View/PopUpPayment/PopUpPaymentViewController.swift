//
//  PopUpPaymentViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 29/11/2024.
//

import UIKit

protocol PopUpPaymentViewControllerDelegate {
    func didTapViewOrder()
    func didTapHomeScreen()
}

class PopUpPaymentViewController: UIViewController {
    var delegate: PopUpPaymentViewControllerDelegate?

    @IBOutlet var contentView: UIView!
    @IBOutlet var titleLabel: HeadingLabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var descriptionLabel: BodyLabel!
    @IBOutlet var backView: UIView!
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configView()
    }

    func configView() {
        view.backgroundColor = .clear
        backView.backgroundColor = .black.withAlphaComponent(0.6)
        backView.alpha = 0
        contentView.alpha = 0
        contentView.layer.cornerRadius = 10
    }

    func appear(sender: UIViewController, isSuccess: Bool) {
        sender.present(self, animated: false) {
            self.show()
            if isSuccess {
                self.titleLabel.text = "Đặt hàng thành công"
                self.imageView.image = UIImage.successPayment
                self.descriptionLabel.text = "Bạn đã đặt hàng thành công"
            } else {
                self.titleLabel.text = "Đặt hàng thất bại"
                self.imageView.image = UIImage.errorPayment
                self.descriptionLabel.text = "Đặt hàng thất bại"
            }
        }
    }

    private func show() {
        UIView.animate(withDuration: 0.3, delay: 0.1) {
            self.backView.alpha = 1
            self.contentView.alpha = 1
        }
    }

    func hide() {
        UIView.animate(withDuration: 0.3, delay: 0.0) {
            self.backView.alpha = 0
            self.contentView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }

    @IBAction func didTapViewOrder(_: Any) {
        hide()
        delegate?.didTapViewOrder()
    }

    @IBAction func didTapHomeScreen(_: Any) {
        hide()
        delegate?.didTapHomeScreen()
    }
}
