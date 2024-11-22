//
//  EditProfileViewModel.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 04/10/2024.
//

import Combine
import Foundation

protocol EditProfileViewModelDelegate {
    func updateProfile(profile: ProfileItem)
}

class EditProfileViewModel: ObservableObject {
    var delegate: EditProfileViewModelDelegate?
    @Published var fullName: String = ""
    @Published var birthDate: String = ""
    @Published var email: String = ""
    @Published var country: String = ""
    @Published var phone: String = ""

    @Published var errorMessage: String? = nil
    private let editProfileUseCase: EditProfileUseCase
    private var cancellables = Set<AnyCancellable>()

    init(editProfileUseCase: EditProfileUseCase) {
        self.editProfileUseCase = editProfileUseCase
    }

    func updateProfile(completion: @escaping (Result<ProfileResponse, Error>) -> Void) {
        if fullName.isEmpty || birthDate.isEmpty || country.isEmpty || phone.isEmpty {
            errorMessage = "Please fill all your field"
        } else if !phone.isValidVietnamesePhoneNumber() {
            errorMessage = "Please fill your phone number (VietNam)"
        } else {
            let name = fullName.split(separator: " ").map(String.init)

            let parameter = [
                "firstName": name[0],
                "lastName": name[1],
                "birthDay": birthDate,
                "phone": phone,
                "address": country,
                "email": email,
            ]
            editProfileUseCase.execute(parameter: parameter)
                .sink(receiveCompletion: { result in
                    print("Completion: \(result)")
                    switch result {
                    case .finished:
                        break
                    case let .failure(failure):
                        self.errorMessage = failure.localizedDescription
                    }
                }, receiveValue: { response in
                    print("response:  \(response)")
                    completion(.success(response))
                    guard let delegate = self.delegate else {
                        return
                    }
                    if response.status == HTTPStatus.success.message {
                        delegate.updateProfile(profile: response.data)
                    }
                }).store(in: &cancellables)
        }
    }
}
