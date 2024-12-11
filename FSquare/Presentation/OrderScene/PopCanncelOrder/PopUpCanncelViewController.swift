//
//  PopUpCanncelViewController.swift
//  FSquare
//
//  Created by Louis Macbook on 09/12/2024.
//

import UIKit

protocol PopUpCanncelDelegate: AnyObject {
    func didSuccess()
}

class PopUpCanncelViewController: UIViewController {
    var delegate: PopUpCanncelDelegate?
    @IBOutlet var contentView: UIView!
    @IBOutlet var backGroundView: UIView!
    private var option: String = "Đổi ý, không mua nữa"
    @IBOutlet var stackViewOption: UIStackView!
    @IBOutlet var optionButton1: UIButton!
    @IBOutlet var optionOther: UIButton!
    @IBOutlet var optionButton3: UIButton!
    @IBOutlet var optionButton2: UIButton!
    private var optionButtons: [UIButton] = []

    @IBOutlet var contentField: NormalField!
    private var idOrder: String = ""
    private var viewModel: MyOrderViewModel?

    init(viewModel: MyOrderViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        optionButtons = [optionButton1, optionOther, optionButton3, optionButton2]
        configView()
    }

    func configView() {
        view.backgroundColor = .clear
        backGroundView.backgroundColor = .black.withAlphaComponent(0.6)
        backGroundView.alpha = 0
        contentView.alpha = 0
        contentView.layer.cornerRadius = 10
    }

    func appear(sender: UIViewController, idOrder: String) {
        self.idOrder = idOrder
        sender.present(self, animated: false) {
            self.show()
        }
    }

    private func show() {
        UIView.animate(withDuration: 0.3, delay: 0.1) {
            self.backGroundView.alpha = 1
            self.contentView.alpha = 1
        }
    }

    func hide() {
        UIView.animate(withDuration: 0.3, delay: 0.0) {
            self.backGroundView.alpha = 0
            self.contentView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }

    @IBAction func didtapOption1(_: Any) {
        option = optionButton1.titleLabel?.text ?? ""
        DispatchQueue.main.async {
            self.updateButtonStates(selectedButton: self.optionButton1)
        }
    }

    @IBAction func didTapOption2(_: Any) {
        option = optionButton2.titleLabel?.text ?? ""
        DispatchQueue.main.async {
            self.updateButtonStates(selectedButton: self.optionButton2)
        }
    }

    @IBAction func didTapOption3(_: Any) {
        option = optionButton3.titleLabel?.text ?? ""
        DispatchQueue.main.async {
            self.updateButtonStates(selectedButton: self.optionButton3)
        }
    }

    @IBAction func didTapOtherButton(_: Any) {
        option = contentField.text ?? ""
        DispatchQueue.main.async {
            self.updateButtonStates(selectedButton: self.optionOther)
        }
    }

    private func updateButtonStates(selectedButton: UIButton) {
        for button in optionButtons {
            let image = button == selectedButton ? UIImage.Toggle.radioSelected : UIImage.Toggle.radio
            button.setImage(image, for: .normal)
        }
    }

    @IBAction func didTapSubmit(_: Any) {
        if optionOther.imageView?.image == UIImage.Toggle.radioSelected {
            option = contentField.text ?? ""
        }
        if option == "" {
            showToast(message: "Hãy nhập lý do huỷ đơn", chooseImageToast: .warning)
        } else {
            viewModel?.patchOrderStatus(idOrder: idOrder, newStatus: "cancelled", content: option) { completion in
                switch completion {
                case let .success(response):
                    print(response)
                    self.hide()
                    self.delegate?.didSuccess()
                case let .failure(error):
                    self.showToast(message: "\(error.localizedDescription)", chooseImageToast: .warning)
                }
            }
        }
    }

    @IBAction func didTapCanncel(_: Any) {
        hide()
    }
}
