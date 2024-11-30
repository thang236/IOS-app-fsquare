//
//  MyOrderViewModel.swift
//  Shang_Buyer
//
//  Created by ThangHT on 29/11/2024.
//

import Foundation
import Combine

enum OrderStatus: String {
    case pending = "pending"
    case processing = "processing"
    case shipped = "shipped"
    case delivered = "delivered"
    case confirmed = "confirmed"
    case cancelled = "cancelled"
    case returned = "returned"
    
    var title: String {
        switch self {
        case .pending:
            return "Chờ xác nhận"
        case .processing:
            return "Chuẩn bị hàng"
        case .shipped:
            return "Đang vận chuyển"
        case .delivered:
            return "Đang giao"
        case .confirmed:
            return "Đã nhận"
        case .cancelled:
            return "Đã hủy"
        case .returned:
            return "Đã trả"
        }
    }
    
    static let allStatuses: [OrderStatus] = [.pending, .processing, .shipped, .delivered, .confirmed, .cancelled, .returned]
}


class MyOrderViewModel: ObservableObject {
    @Published var orderStatusResponse: OrderStatusResponse?
    var orderUseCase: OrderUseCase
    
    var cancellables = Set<AnyCancellable>()
    
    init(orderUseCase: OrderUseCase) {
        self.orderUseCase = orderUseCase
    }
    
    func getOrder(orderStatus: OrderStatus, completion: (() -> Void)? = nil) {
        let parameter: [String: Any] = ["status": orderStatus.rawValue]
        orderUseCase.getOrderStatus(parameter: parameter)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    print(error)
                }
            } receiveValue: { orderStatusResponse in
                self.orderStatusResponse = orderStatusResponse
                completion?()
            }.store(in: &cancellables)
    }

    
    
}
