//
//  LoadingViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 20/09/2024.
//

import UIKit
import Combine

class LoadingViewController: UIViewController {
    var coordinator: AuthCoordinator?
    private var viewModel: LoadingViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: LoadingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
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
//                self?.showToast(message: errorMessage, chooseImageToast: .error)
                self?.showAlert(title: "error", message: errorMessage)
                
            }.store(in: &cancellables)
    }
    
    
    func checkRemember() {
        let check = UserDefaults.standard.bool(forKey: .rememberMe)
        print(check)
            if check {
                checkToken()
            } else {
                self.coordinator?.goToLoginMethodSelection()
            }
    }
    
    func checkToken() {
        if TokenManager.shared.getAccessToken() != nil {
            viewModel.getProfile() { completion in
                switch completion {
                case .success(let data):
                    if data.status == HTTPStatus.success.message {
                        let tabVC = TabViewController()
                        self.navigationController?.pushViewController(tabVC, animated: true)
                    } else {
                        self.showToast(message: "Please Login again", chooseImageToast: .warning)
                        self.coordinator?.goToLoginMethodSelection()
                    }
                case .failure(let failure):
                    self.showToast(message: "error: \(failure)", chooseImageToast: .error)
                    self.coordinator?.goToLoginMethodSelection()
                }
            }
        } else {
            self.coordinator?.goToLoginMethodSelection()
        }
    }
}
