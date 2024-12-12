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
    private let navigationMain: UINavigationController

    init(navigationMain: UINavigationController) {
        self.navigationMain = navigationMain
        let profileViewModel = DIContainer.shared.resolveProfileViewModel()
        let profileVC = ProfileViewController(viewModel: profileViewModel)
        navigationController = UINavigationController(rootViewController: profileVC)
        profileVC.coordinator = self
    }

    func getNavigationController() -> UINavigationController {
        return navigationController
    }

    func start() {}

    func goToEditProfile(profileModel: ProfileItem, vc: EditProfileViewModelDelegate) {
        let editProfileViewModel = DIContainer.shared.resolveEditProfileViewModel()
        editProfileViewModel.delegate = vc.self
        let editProfileVC = EditProfileViewController(viewModel: editProfileViewModel, profileModel: profileModel)
        editProfileVC.coordinator = self
        navigationController.pushViewController(editProfileVC, animated: true)
    }

    // MARK: - Address

    func goToAddress() {
        let addressViewModel = DIContainer.shared.resolveAddressViewModel()
        let addressVC = AddressViewController(viewModel: addressViewModel)
        addressVC.coordinator = self
        navigationController.pushViewController(addressVC, animated: true)
    }

    func gotoAddAddress(addressViewModel: AddressViewModel) {
        let addAddessVC = AddNewAddressViewController(viewModel: addressViewModel)
        addAddessVC.coordinator = self
        navigationController.pushViewController(addAddessVC, animated: true)
    }

    func goToChooseLocation(viewModel: AddressViewModel, chooseLocationType: ChooseLocationType) {
        let chooseLocationVC = ChooseLocationViewController(viewModel: viewModel, chooseLocationType: chooseLocationType)
        navigationController.pushViewController(chooseLocationVC, animated: true)
    }

    func goToEditAddress(viewModel: AddressViewModel, address: AddressData) {
        let editAddress = EditAddressViewController(viewModel: viewModel, address: address)
        editAddress.coordinator = self
        navigationController.pushViewController(editAddress, animated: true)
    }

    func goToNotification() {
        let notificationViewModel = DIContainer.shared.resolveNotificationViewModel()
        let notiVC = NotificationViewController(viewModel: notificationViewModel)
        navigationController.pushViewController(notiVC, animated: true)
    }
    
    func goToChinhSach() {
        let chinhSachVC = ChinhSachViewController()
        navigationController.pushViewController(chinhSachVC, animated: true)
    }

    func logoutUser() {
        let authCoordinator = AuthCoordinator(navigationController: navigationMain)
        navigationMain.isNavigationBarHidden = false
        authCoordinator.goToLoginMethodSelection()
    }
}
