//
//  EditProfileViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 04/10/2024.
//

import Combine
import UIKit

class EditProfileViewController: UIViewController {
    var coordinator: ProfileCoordinator?

    @IBOutlet var lastNameField: NormalField!
    @IBOutlet var birthField: NormalField!
    @IBOutlet var emailField: NormalField!
    @IBOutlet var firstField: NormalField!
    @IBOutlet var phoneField: NormalField!

    private var viewModel: EditProfileViewModel
    private var cancellables = Set<AnyCancellable>()
    private var profileModel: ProfileItem

    private var currentDate = Date()
    private let datePicker = UIDatePicker()

    init(viewModel: EditProfileViewModel, profileModel: ProfileItem) {
        self.profileModel = profileModel
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
        setupBindings()
        setupField()
        setupDatePicker()
    }

    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: .valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        datePicker.preferredDatePickerStyle = .wheels
        birthField.inputView = datePicker
        if let date = profileModel.birthDay {
            birthField.text = date.toShortDate()
        } else {
            birthField.text = currentDate.formatDateToString()
        }
    }

    @objc private func dateChange(datePicker: UIDatePicker) {
        birthField.text = datePicker.date.formatDateToString()
    }

    private func setupField() {
        firstField.text = profileModel.firstName
        lastNameField.text = profileModel.lastName
        birthField.text = profileModel.birthDay ?? ""
        emailField.text = profileModel.email
        phoneField.text = profileModel.phone ?? ""
        emailField.isEnabled = false
    }

    private func setupBindings() {
        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main).sink { [weak self] errorMessage in
                self?.showToast(message: errorMessage, chooseImageToast: .warning)
            }.store(in: &cancellables)
    }

    func setupNav() {
        navigationItem.hidesBackButton = true
        let image: UIImage = #imageLiteral(resourceName: "positionLeft")
        guard let size = navigationController?.navigationBar.frame.height else {
            return
        }
        let resizedImage = image.resizeImage(targetSize: CGSize(width: size, height: size))
        let backButton = UIBarButtonItem(image: resizedImage, style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .neutralUltraDark
        setupNavigationBar(leftBarButton: backButton, title: "Chỉnh sửa hồ sơ", rightBarButton: nil)
    }

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    override func viewWillAppear(_: Bool) {
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_: Bool) {
        tabBarController?.tabBar.isHidden = false
    }

    @IBAction func didTapUpdateButton(_: Any) {
        viewModel.firstName = firstField.text ?? ""
        viewModel.lastName = lastNameField.text ?? ""
        viewModel.birthDate = birthField.text ?? ""
        viewModel.phone = phoneField.text ?? ""
        guard let email = profileModel.email else {
            return
        }
        viewModel.email = email
        viewModel.updateProfile { completion in
            switch completion {
            case let .success(success):
                if success.status == HTTPStatus.success.message {
                    self.showToast(message: success.message, chooseImageToast: .success)
                }
            case let .failure(failure):
                self.showToast(message: failure.localizedDescription, chooseImageToast: .error)
            }
        }
    }
}
