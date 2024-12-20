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
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var birthDate: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""

    @Published var errorMessage: String? = nil
    private let editProfileUseCase: EditProfileUseCase
    private var cancellables = Set<AnyCancellable>()

    init(editProfileUseCase: EditProfileUseCase) {
        self.editProfileUseCase = editProfileUseCase
    }

    func updateProfile(completion: @escaping (Result<ProfileResponse, Error>) -> Void) {
        if firstName.isEmpty || birthDate.isEmpty || phone.isEmpty || lastName.isEmpty {
            errorMessage = "Xin hãy điền đủ các trường"
        } else if !phone.isValidVietnamesePhoneNumber() {
            errorMessage = "Hãy nhập số điện thoại hợp lệ"
        } else {
            print("birthDay: \(birthDate)")
            let parameter = [
                "firstName": firstName,
                "lastName": lastName,
                "birthDay": birthDate,
                "phone": phone,
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
                        let nameUser = "\(response.data.firstName) \(response.data.lastName)"
                        let phoneUser = response.data.phone
                        UserDefaults.standard.set(nameUser, forKey: .nameUser)
                        UserDefaults.standard.set(phoneUser, forKey: .phoneUser)
                        delegate.updateProfile(profile: response.data)
                    }
                }).store(in: &cancellables)
        }
    }
}
