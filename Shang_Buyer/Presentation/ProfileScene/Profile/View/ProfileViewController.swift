//
//  ProfileViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 02/10/2024.
//

import Combine
import UIKit

class ProfileViewController: UIViewController {
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
        let image = UIImage.moreHorizontal
        let resize = image.resizeImage(targetSize: CGSize(width: 32, height: 32))
        let moreButton = UIBarButtonItem(image: resize, style: .plain, target: self, action: #selector(didTapMoreButton))
        moreButton.tintColor = .black
        setupNavigationBar(title: "Profile", rightBarButton: [moreButton])
    }

    @objc func didTapMoreButton() {}

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTableViewAppearance()
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
        if let phone = profile.phone {
            phoneLabel.text = "\(phone)"
        } else {
            phoneLabel.text = "please update phone number"
            return
        }
    }

    @IBAction func didTabEditProfile(_: Any) {
//        let editProfileVC = EditProfileViewController()
//        navigationController?.pushViewController(editProfileVC, animated: true)
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
            guard let profile = profile else {
                return
            }
            coordinator?.goToEditProfile(profileModel: profile, vc: self)
        case .address:
            if let token = TokenManager.shared.getAccessToken() {
                print("Token: \(token)")
                coordinator?.goToAddress()
            } else {
                showAlert(title: "Alert", message: "Please login to use this feature")
            }
        case .noti:
            print("111")
        case .wallet:
            print("111")
        case .security:
            print("111")
        case .policy:
            print("111")
        case .logout:
            TokenManager.shared.removeTokens()
            UserDefaults.standard.set(false, forKey: .rememberMe)
            coordinator?.logoutUser()
        }
    }
}

extension ProfileViewController: EditProfileViewModelDelegate {
    func updateProfile(profile: ProfileItem) {
        setupProfile(profile: profile)
    }
}
