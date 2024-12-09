//
//  NotificationViewModel.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 05/12/2024.
//

import Combine
import Foundation

class NotificationViewModel: ObservableObject {
    private let useCase: NotificationUseCase

    @Published var notificationResponse: NotificationsResponse? = nil
    @Published var notificationData: [NotificationData] = []
    @Published var errorMessage: String? = nil

    var cancellables = Set<AnyCancellable>()

    init(useCase: NotificationUseCase) {
        self.useCase = useCase
    }

    func getNotifications() {
        let parameter: [String: Any] = [
            "size": 50,
            "page": 1,
        ]
        useCase.getNotifications(parameter: parameter)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    print("Error: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { response in
                self.notificationResponse = response
                self.notificationData = response.data
            })
            .store(in: &cancellables)
    }
}
