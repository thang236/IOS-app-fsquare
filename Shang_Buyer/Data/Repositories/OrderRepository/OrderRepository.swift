//
//  OrderRepository.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 26/11/2024.
//

import Combine
import Foundation

protocol OrderRepository {
    func calculatorFee(parameter: [String: Any]) -> AnyPublisher<FeeResponse, Error>
    func createOrder(parameter: OrderRequest) -> AnyPublisher<OrderResponse, Error>
    func postPayment(parameter: [String: Any]) -> AnyPublisher<PostPaymentResponse, Error>
    func getOrderStatus(parameter: [String: Any]) -> AnyPublisher<OrderStatusResponse, Error>
    func getOrderDetail(idOrder: String) -> AnyPublisher<OrderResponse, Error>
    func patchOrderStatus(idOrder: String, newStatus: String) -> AnyPublisher<OrderResponse, Error>
    func returnOrder(idOrder: String, reason: String) -> AnyPublisher<OrderResponse, Error>
}

class OrderRepositoryImpl: OrderRepository {
    let apiService: APIService

    init(apiService: APIService) {
        self.apiService = apiService
    }

    func calculatorFee(parameter: [String: Any]) -> AnyPublisher<FeeResponse, Error> {
        apiService.request(endpoint: .fee, method: .post, parameters: parameter)
    }

    func createOrder(parameter: OrderRequest) -> AnyPublisher<OrderResponse, Error> {
        apiService.request(endpoint: .order, method: .post, parameters: parameter)
    }

    func postPayment(parameter: [String: Any]) -> AnyPublisher<PostPaymentResponse, Error> {
        apiService.request(endpoint: .payments, method: .post, parameters: parameter)
    }

    func getOrderStatus(parameter: [String: Any]) -> AnyPublisher<OrderStatusResponse, Error> {
        apiService.request(endpoint: .order, method: .get, parameters: parameter)
    }

    func getOrderDetail(idOrder: String) -> AnyPublisher<OrderResponse, Error> {
        apiService.request(endpoint: .orderID(idOrder: idOrder), method: .get, parameters: nil)
    }

    func patchOrderStatus(idOrder: String, newStatus: String) -> AnyPublisher<OrderResponse, Error> {
        apiService.request(endpoint: .orderID(idOrder: idOrder), method: .patch, parameters: ["newStatus": newStatus])
    }

    func returnOrder(idOrder: String, reason: String) -> AnyPublisher<OrderResponse, Error> {
        apiService.request(endpoint: .orderReturn(idOrder: idOrder), method: .patch, parameters: ["reason": reason])
    }
}
