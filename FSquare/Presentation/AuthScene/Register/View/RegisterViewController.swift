//
//  RegisterViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 25/09/2024.
//

import Combine
import UIKit

class RegisterViewController: UIViewController {
    var coordinator: AuthCoordinator?
    @IBOutlet private var emailField: NormalField!
    @IBOutlet private var checkButton: UIButton!
    private var viewModel: RegisterViewModel
    private var cancellables = Set<AnyCancellable>()

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
        setUpNavigationBar()
        setupBindings()
    }
    override func viewWillAppear(_ animated: Bool) {
        toggleCheckBox()
    }

    private func setUpNavigationBar() {
        navigationItem.hidesBackButton = true
        let image: UIImage = #imageLiteral(resourceName: "positionLeft")
        guard let size = navigationController?.navigationBar.frame.height else {
            return
        }
        let resizedImage = image.resizeImage(targetSize: CGSize(width: size, height: size))
        let backButton = UIBarButtonItem(image: resizedImage, style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .neutralUltraDark
        navigationItem.leftBarButtonItem = backButton
    }

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func didTapCheckBox(_: Any) {
        viewModel.checkAgree.toggle()
        toggleCheckBox()
    }

    func toggleCheckBox() {
        if viewModel.checkAgree {
            let icon = UIImage.Toggle.focusTrue
            checkButton.setImage(icon, for: .normal)
            viewModel.checkAgree = true
        } else {
            let icon = UIImage.Toggle.focusFalse
            checkButton.setImage(icon, for: .normal)
            viewModel.checkAgree = false
        }
    }

    private func setupBindings() {
        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main).sink { [weak self] errorMessage in
                self?.showToast(message: errorMessage, chooseImageToast: .error)
            }.store(in: &cancellables)
    }

    @IBAction func didTapCreateAccount(_: Any) {
        guard let email = emailField.text, !email.isEmpty else {
            showToast(message: "Hãy nhập email", chooseImageToast: .warning)
            return
        }
        if email.isValidEmail() {
            if viewModel.checkAgree {
                DispatchQueue.main.async {
                    self.viewModel.email = email
                    self.viewModel.register { completion in
                        switch completion {
                        case let .success(authResponse):
                            if authResponse.status == HTTPStatus.success.message || authResponse.status == HTTPStatus.created.message {
                                self.coordinator?.goToVerifyOTP(vc: self, email: email)
                            } else {
                                self.showToast(message: authResponse.message, chooseImageToast: .error)
                            }
                        case let .failure(error):
                            self.showToast(message: error.localizedDescription, chooseImageToast: .error)
                        }
                    }
                }
            } else {
                showToast(message: "Bạn phải đồng ý với điều khoản", chooseImageToast: .warning)
            }

        } else {
            showToast(message: "Email không hợp lệ", chooseImageToast: .warning)
        }
    }
    
    @IBAction func didTappolicyButton(_ sender: Any) {
        let policyVC = PolicyViewController(viewModel: viewModel)
        navigationController?.pushViewController(policyVC, animated: true)
    }
}

extension RegisterViewController: VerifyOTPViewControllerDelegate {
    func resendOTP() {
        viewModel.register { _ in
        }
    }
}
