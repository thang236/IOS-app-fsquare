//
//  VerifyOTPViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 26/09/2024.
//

import Combine
import UIKit

protocol VerifyOTPViewControllerDelegate {
    func resendOTP()
}

class VerifyOTPViewController: UIViewController {
    var delegate: VerifyOTPViewControllerDelegate?
    var coordinator: AuthCoordinator?
    private var isLogin: Bool = false
    @IBOutlet var otpField: OTPTextField!
    var countdownTimer: Timer?
    var remainingSeconds = 60

    @IBOutlet private var refreshOTPButton: GhostButton!
    private var viewModel: VerifyOTPViewModel
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: VerifyOTPViewModel, email: String, isLogin: Bool) {
        self.isLogin = isLogin
        self.viewModel = viewModel
        self.viewModel.email = email
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        otpField.configure()
        setUpNavigationBar()
        setupBindings()
        startCountdown()
    }

    func startCountdown() {
        refreshOTPButton.isEnabled = false
        refreshOTPButton.setTitle("\(remainingSeconds)s", for: .disabled)
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }

    @objc func updateCountdown() {
        if remainingSeconds > 0 {
            remainingSeconds -= 1
            refreshOTPButton.setTitle("\(remainingSeconds)s", for: .disabled)
        } else {
            endCountdown()
        }
    }

    @IBAction func didTapResendCode(_: Any) {
        guard let delegate = delegate else {
            return
        }
        delegate.resendOTP()
        startCountdown()
    }

    func endCountdown() {
        countdownTimer?.invalidate()
        countdownTimer = nil
        refreshOTPButton.isEnabled = true
        refreshOTPButton.setTitle("Gửi lại", for: .normal)

        remainingSeconds = 60
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

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    private func setupBindings() {
        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main).sink { [weak self] errorMessage in
                self?.showToast(message: "\(errorMessage) OTP, Hãy thử lại", chooseImageToast: .error)

            }.store(in: &cancellables)
    }

    @IBAction func didTapSubmit(_: Any) {
        validateInput()
    }

    private func validateInput() {
        guard let otpCode = otpField.text, !otpCode.isEmpty else {
            showToast(message: "Hãy xác thực OTP", chooseImageToast: .warning)
            return
        }
        viewModel.otp = otpCode

        viewModel.verifyOTP(isLogin: isLogin) { result in
            switch result {
            case let .success(authResponse):
                guard let token = authResponse.data else {
                    return
                }

                TokenManager.shared.saveAccessToken(token)
                DispatchQueue.main.async {
                    if self.isLogin {
                        self.coordinator?.didFinishAuthentication()
                    } else {
                        self.coordinator?.gotoSuccessRegister()
                    }
                }

            case let .failure(error):
                self.showToast(message: error.localizedDescription, chooseImageToast: .error)
            }
        }
    }
}
