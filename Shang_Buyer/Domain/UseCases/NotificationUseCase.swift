//
//  NotificationUseCase.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 05/12/2024.
//

import Combine
import Foundation

protocol NotificationUseCase {
    func getNotifications(parameter: [String: Any]) -> AnyPublisher<NotificationsResponse, Error>
}

class NotificationUseCaseImpl: NotificationUseCase {
    private let repository: NotificationRepository

    init(repository: NotificationRepository) {
        self.repository = repository
    }

    func getNotifications(parameter: [String: Any]) -> AnyPublisher<NotificationsResponse, Error> {
        repository.getNotifications(parameter: parameter)
    }
}
