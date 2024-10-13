//
//  LoadingViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 20/09/2024.
//

import Combine
import UIKit

class LoadingViewController: UIViewController {
    var coordinator: AuthCoordinator?
    private var viewModel: LoadingViewModel
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: LoadingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        checkRemember()
    }

    private func setupBindings() {
        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main).sink { [weak self] errorMessage in
                print("errorMessage:   \(errorMessage)")
                if errorMessage == "Token is obsolete" {
                    self?.coordinator?.goToLoginMethodSelection()
                }
                self?.showToast(message: errorMessage, chooseImageToast: .error)
            }.store(in: &cancellables)
    }

    func checkRemember() {
        let check = UserDefaults.standard.bool(forKey: .rememberMe)
        if check {
            checkToken()
        } else {
            coordinator?.goToLoginMethodSelection()
        }
    }

    func checkToken() {
        if TokenManager.shared.getAccessToken() != nil {
            viewModel.getProfile { completion in
                switch completion {
                case let .success(data):
                    if data.status == HTTPStatus.success.message {
                        self.coordinator?.didFinishAuthentication()
                    } else {
                        self.showToast(message: "Please Login again", chooseImageToast: .warning)
                        self.coordinator?.goToLoginMethodSelection()
                    }
                case let .failure(failure):
                    self.showToast(message: "error: \(failure)", chooseImageToast: .error)
                    self.coordinator?.goToLoginMethodSelection()
                }
            }
        } else {
            coordinator?.goToLoginMethodSelection()
        }
    }
}
