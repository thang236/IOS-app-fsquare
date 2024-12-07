//
//  ReturnOrderViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 05/12/2024.
//

import UIKit

protocol ReturnOrderViewControllerDelegate {
    func didTapSubmitReturn(content: String)
}

class ReturnOrderViewController: UIViewController {
    var delegate: ReturnOrderViewControllerDelegate?

    @IBOutlet var contentField: NormalField!
    @IBOutlet var backView: UIView!
    @IBOutlet var contentView: UIView!

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

    func appear(sender: UIViewController) {
        sender.present(self, animated: false) {
            self.show()
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

    @IBAction func didTapCancel(_: Any) {
        hide()
    }

    @IBAction func didTapSubmit(_: Any) {
        if let text = contentField.text, !text.isEmpty {
            delegate?.didTapSubmitReturn(content: text)
            hide()
        } else {
            showToast(message: "Vui lòng nhập nội dung", chooseImageToast: .warning)
        }
    }
}
