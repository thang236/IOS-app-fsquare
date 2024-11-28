//
//  OrderUseCase.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 26/11/2024.
//

import Foundation
import Combine

protocol OrderUseCase {
    func calculatorFee(parameter: [String: Any]) -> AnyPublisher<FeeResponse, Error>
    func createOrder(parameter: OrderRequest) -> AnyPublisher<OrderResponse, Error>
}

class OrderUseCaseImpl: OrderUseCase {
    private let repository: OrderRepository
    
    init(repository: OrderRepository) {
        self.repository = repository
    }
    
    func calculatorFee(parameter: [String : Any]) -> AnyPublisher<FeeResponse, Error> {
        repository.calculatorFee(parameter: parameter)
    }
    
    func createOrder(parameter: OrderRequest) -> AnyPublisher<OrderResponse, Error> {
        repository.createOrder(parameter: parameter)
    }
    
}

