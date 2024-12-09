//
//  ProfileViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 02/10/2024.
//

import Combine
import Photos
import UIKit

class ProfileViewController: UIViewController {
    let imagePicker = UIImagePickerController()
    private var profile: ProfileItem? = nil
    var coordinator: ProfileCoordinator?
    private let profiles: [Profile] = Profile.profiles
    @IBOutlet private var profileTableView: UITableView!
    @IBOutlet private var phoneLabel: BodyLabel!
    @IBOutlet private var fullNameLabel: HeadingLabel!
    @IBOutlet private var avatarImage: UIImageView!
    private var cancellables = Set<AnyCancellable>()

    let viewModel: ProfileViewModel
    init(viewModel: ProfileViewModel) {
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
        getProfile()
        setupNav()
        setupTableView()
    }

    private func setupTableView() {
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.registerCell(cellType: ProfileTableViewCell.self)
        profileTableView.isScrollEnabled = false
    }

    private func setupTableViewAppearance() {
        profileTableView.layer.cornerRadius = 16
        profileTableView.layer.masksToBounds = true
        profileTableView.layer.borderWidth = 1
        profileTableView.layer.borderColor = UIColor.borderLight.cgColor

        profileTableView.layer.shadowColor = UIColor.black.cgColor
        profileTableView.layer.shadowOffset = CGSize(width: 10, height: 10)
        profileTableView.layer.shadowOpacity = 0.4
        profileTableView.layer.shadowRadius = 10
    }

    private func setupNav() {
        setupNavigationBar(title: "Hồ sơ cá nhân")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTableViewAppearance()
        avatarImage.cornerRadius = avatarImage.frame.height / 2
    }
    

    private func setupBindings() {
        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                print("errorMessage:   \(errorMessage)")
                self?.showToast(message: errorMessage, chooseImageToast: .error)

            }.store(in: &cancellables)
    }

    private func getProfile() {
        viewModel.getProfile { completion in
            switch completion {
            case let .success(data):
                self.profile = data.data
                guard let profile = self.profile else {
                    return
                }
                self.setupProfile(profile: profile)
            case let .failure(failure):
                self.showToast(message: failure.localizedDescription, chooseImageToast: .warning)
            }
        }
    }

    private func setupProfile(profile: ProfileItem) {
        fullNameLabel.text = "\(profile.firstName) \(profile.lastName)"
        if let avatar = profile.avatar?.url {
            if let url = URL(string: avatar) {
                avatarImage.loadImageWithShimmer(url: url, placeholderImage: .avartar)
            }
        }
        if let phone = profile.phone {
            phoneLabel.text = "\(phone)"
        } else {
            phoneLabel.text = "please update phone number"
            return
        }
    }

    @IBAction func didTabEditProfile(_: Any) {
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.mediaTypes = ["public.image"]
        imagePicker.title = "Hãy chọn ảnh đại diện"

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    func showMyViewControllerInACustomizedSheet() {
        let viewControllerToPresent = SheetLogoutViewController()
        viewControllerToPresent.delegate = self
        if let sheet = viewControllerToPresent.sheetPresentationController {
            let seventyPercentDetent = UISheetPresentationController.Detent.custom { context in
                context.maximumDetentValue * 0.25
            }

            sheet.detents = [seventyPercentDetent]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            sheet.prefersGrabberVisible = true
        }
        present(viewControllerToPresent, animated: true, completion: nil)
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        let tableViewHeight = tableView.frame.height
        return tableViewHeight / CGFloat(profiles.count)
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return profiles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: ProfileTableViewCell.self, at: indexPath)
        cell.setUpTableView(profile: profiles[indexPath.row])
        cell.selectionStyle = .none

        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexSelected = SettingProfileTable(rawValue: indexPath.row)!
        switch indexSelected {
        case .editProfile:
            if TokenManager.shared.getAccessToken() != nil {
                guard let profile = profile else {
                    return
                }
                coordinator?.goToEditProfile(profileModel: profile, vc: self)
            } else {
                showToast(message: "Vui lòng đăng nhập để sử dụng tính năng này", chooseImageToast: .warning)
            }
        case .address:
            if TokenManager.shared.getAccessToken() != nil {
                coordinator?.goToAddress()
            } else {
                showToast(message: "Vui lòng đăng nhập để sử dụng tính năng này", chooseImageToast: .warning)
            }
        case .noti:
            if TokenManager.shared.getAccessToken() != nil {
                coordinator?.goToNotification()
            } else {
                showToast(message: "Vui lòng đăng nhập để sử dụng tính năng này", chooseImageToast: .warning)
            }
        case .policy:
            print("111")
        case .logout:
            if TokenManager.shared.getAccessToken() != nil {
                showMyViewControllerInACustomizedSheet()
            } else {
                coordinator?.logoutUser()
            }
        }
    }
}

extension ProfileViewController: EditProfileViewModelDelegate {
    func updateProfile(profile: ProfileItem) {
        setupProfile(profile: profile)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if info[.mediaType] as? String == "public.image" {
            handlePhoto(info)
        } else {
            print("DEBUG PRINT:", "Unsupported media type.")
        }

        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }

    // MARK: - Images

    private func handlePhoto(_ info: [UIImagePickerController.InfoKey: Any]) {
        if let asset = info[.phAsset] as? PHAsset {
            print("DEBUG PRINT:", asset.location ?? "No location")
            print("DEBUG PRINT:", asset.creationDate?.description ?? "No creation date")
            print("DEBUG PRINT:", asset.pixelHeight)
            print("DEBUG PRINT:", asset.pixelWidth)
        }

        if let image = info[.originalImage] as? UIImage {
            viewModel.updateProfile(avartar: image) { completion in
                switch completion {
                case let .success(success):
                    if success.status == HTTPStatus.success.message {
                        self.avatarImage.image = image
                        self.showToast(message: "Cập nhật thành công", chooseImageToast: .success)
                    }
                case let .failure(failure):
                    self.showToast(message: failure.localizedDescription, chooseImageToast: .error)
                }
            }
        }
    }
}
extension ProfileViewController: SheetLogoutViewControllerDelegate {
    func didTapLogoutButton() {
        TokenManager.shared.removeTokens()
        UserDefaults.standard.set(false, forKey: .rememberMe)
        coordinator?.logoutUser()
    }
}
