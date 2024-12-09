//
//  VerifyOTPViewModel.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 27/09/2024.
//

import Combine
import Foundation

class VerifyOTPViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var otp: String = ""
    @Published var errorMessage: String? = nil

    private let verifyOTPUseCase: VerifyOTPUseCase
    private var cancellables = Set<AnyCancellable>()

    init(verifyOTPUseCase: VerifyOTPUseCase) {
        self.verifyOTPUseCase = verifyOTPUseCase
    }

    func verifyOTP(isLogin: Bool, completion: @escaping (Result<AuthResponse, Error>) -> Void) {
        let type = isLogin ? "login" : "signup"

        let parameter = ["otp": otp,
                         "email": email,
                         "type": type,
                         "fcmToken": ""]
        verifyOTPUseCase.execute(parameter: parameter)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("complete")
                case let .failure(error):
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { authResponse in
                completion(.success(authResponse))
            }).store(in: &cancellables)
    }
}
