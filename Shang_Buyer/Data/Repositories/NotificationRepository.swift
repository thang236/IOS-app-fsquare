//
//  NotificationRepository.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 05/12/2024.
//

import Foundation
import Combine

protocol NotificationRepository {
    func getNotifications(parameter: [String: Any]) -> AnyPublisher<NotificationsResponse, Error>
}

class NotificationRepositoryImpl: NotificationRepository {
    private let apiService: APIService
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func getNotifications(parameter: [String: Any]) -> AnyPublisher<NotificationsResponse, Error> {
        apiService.request(endpoint: .getNotifications, method: .get, parameters: parameter)
    }
}
