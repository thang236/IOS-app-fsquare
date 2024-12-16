//
//  LoginWithEmailViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 30/09/2024.
//

import Combine
import UIKit

class LoginWithEmailViewController: UIViewController {
    var coordinator: AuthCoordinator?
    private var viewModel: LoginWithEmailViewModel
    @IBOutlet private var emailField: NormalField!

    private var cancellables = Set<AnyCancellable>()

    init(viewModel: LoginWithEmailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init\(coder) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setupBindings()
    }

    func setUpNavigationBar() {
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

    @IBAction func didTapNextButton(_: Any) {
        handleNextButton()
    }

    private func setupBindings() {
        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main).sink { [weak self] errorMessage in
                self?.showToast(message: errorMessage, chooseImageToast: .error)
                self?.viewModel.errorMessage = nil
            }.store(in: &cancellables)
    }

    private func handleNextButton() {
        guard let email = emailField.text, !email.isEmpty else {
            showToast(message: "Hãy nhập email", chooseImageToast: .warning)
            return
        }
        if email.isValidEmail() {
            viewModel.email = email
            login(email: email)
        } else {
            showToast(message: "Email không hợp lệ", chooseImageToast: .warning)
        }
    }

    private func login(email: String) {
        viewModel.loginByEmail { completion in
            switch completion {
            case let .success(authResponse):
                if authResponse.status == HTTPStatus.success.message {
                    self.coordinator?.goToVerifyOTP(vc: self, email: email, isLogin: true)
                } else {
                    self.showToast(message: "Đã có lỗi xảy ra vui lòng thử lại", chooseImageToast: .error)
                }
            case let .failure(error):
                self.showToast(message: error.localizedDescription, chooseImageToast: .error)
            }
        }
    }
}

extension LoginWithEmailViewController: VerifyOTPViewControllerDelegate {
    func resendOTP() {
        viewModel.loginByEmail { _ in
        }
    }
}
