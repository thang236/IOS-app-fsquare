//
//  PolicyViewController.swift
//  FSquare
//
//  Created by Louis Macbook on 06/12/2024.
//

import UIKit

class PolicyViewController: UIViewController {
    @IBOutlet var agreeButton: UIButton!
    private var viewModel: RegisterViewModel
    @IBOutlet var textView: UITextView!
    private var isCheck = false

    init(viewModel: RegisterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        textView.isEditable = false
    }

    private func setupNav() {
        navigationItem.hidesBackButton = true
        let image: UIImage = #imageLiteral(resourceName: "positionLeft")
        guard let size = navigationController?.navigationBar.frame.height else {
            return
        }
        let resizedImage = image.resizeImage(targetSize: CGSize(width: size, height: size))
        let backButton = UIBarButtonItem(image: resizedImage, style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .neutralUltraDark
        setupNavigationBar(leftBarButton: backButton, title: "Đăng ký tài khoản mới", rightBarButton: nil)
    }

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    override func viewWillAppear(_: Bool) {
        isCheck = viewModel.checkAgree
        toggleCheckBox()
    }

    @IBAction func didTapAgreeButton(_: Any) {
        isCheck.toggle()
        toggleCheckBox()
    }

    func toggleCheckBox() {
        if isCheck {
            let icon = UIImage.Toggle.focusTrue
            agreeButton.setImage(icon, for: .normal)
        } else {
            let icon = UIImage.Toggle.focusFalse
            agreeButton.setImage(icon, for: .normal)
        }
    }

    @IBAction func didTapSubmit(_: Any) {
        if isCheck {
            viewModel.checkAgree = isCheck
            navigationController?.popViewController(animated: true)
        } else {
            showToast(message: "Bạn cách phải đồng ý với điều khoản để tiếp tục", chooseImageToast: .warning)
        }
    }
}
