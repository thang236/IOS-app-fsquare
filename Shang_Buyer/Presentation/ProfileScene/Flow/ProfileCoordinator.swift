//
//  ProfileCoordinator.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 07/10/2024.
//

import Foundation
import UIKit

class ProfileCoordinator: Coordinator {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let profileViewModel = DIContainer.shared.resolveProfileViewModel()
        let profileVC = ProfileViewController(viewModel: profileViewModel)
        profileVC.coordinator = self
        navigationController.pushViewController(profileVC, animated: true)
    }

    func getProfile() -> ProfileViewController {
        let profileViewModel = DIContainer.shared.resolveProfileViewModel()
        let profileVC = ProfileViewController(viewModel: profileViewModel)
        profileVC.coordinator = self
        return profileVC
    }

    func goToEditProfile(profileModel: ProfileItem, vc: EditProfileViewModelDelegate) {
        let editProfileViewModel = DIContainer.shared.resolveEditProfileViewModel()
        editProfileViewModel.delegate = vc.self
        let editProfileVC = EditProfileViewController(viewModel: editProfileViewModel, profileModel: profileModel)
        editProfileVC.coordinator = self
        navigationController.pushViewController(editProfileVC, animated: true)
    }

    func logoutUser() {
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        authCoordinator.goToLoginMethodSelection()
    }
}
