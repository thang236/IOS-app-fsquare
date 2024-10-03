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
    @IBOutlet private var rememberButton: UIButton!

    private var checkBox = false
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

    @IBAction func didTapRemberButton(_: Any) {
        checkBox = !checkBox
        toggleCheckBox()
    }

    @IBAction func didTapNextButton(_: Any) {
        handleNextButton()
    }

    private func toggleCheckBox() {
        if checkBox {
            let icon = UIImage.Toggle.focusTrue
            rememberButton.setImage(icon, for: .normal)
        } else {
            let icon: UIImage = UIImage.Toggle.focusFalse
            rememberButton.setImage(icon, for: .normal)
        }
    }

    private func setupBindings() {
        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main).sink { [weak self] errorMessage in
                self?.showToast(message: errorMessage, chooseImageToast: .error)
            }.store(in: &cancellables)
    }

    private func handleNextButton() {
        guard let email = emailField.text, !email.isEmpty else {
            showToast(message: "Please fill your email", chooseImageToast: .warning)
            return
        }
        if email.isValidEmail() {
            viewModel.email = email
            login(email: email)
        } else {
            showToast(message: "invalid email ex: abc@gmail.com", chooseImageToast: .warning)
        }
    }

    private func login(email: String) {
        UserDefaults.standard.set(checkBox, forKey: .rememberMe)
        viewModel.loginByEmail { completion in
            switch completion {
            case let .success(authResponse):
                if authResponse.status == HTTPStatus.success.message {
                    self.coordinator?.goToVerifyOTP(vc: self, email: email, isLogin: true)
                } else {
                    self.showToast(message: "Something is wrong please try again", chooseImageToast: .error)
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
