//
//  MyOrderViewModel.swift
//  Shang_Buyer
//
//  Created by ThangHT on 29/11/2024.
//

import Combine
import Foundation

enum OrderStatus: String {
    case pending
    case processing
    case shipped
    case delivered
    case confirmed
    case cancelled
    case returned

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
            return "Trả hàng"
        }
    }

    static let allStatuses: [OrderStatus] = [.pending, .processing, .shipped, .delivered, .confirmed, .cancelled, .returned]
}

class MyOrderViewModel: ObservableObject {
    @Published var orderStatusResponse: OrderStatusResponse?
    @Published var orderDetailResponse: OrderResponse?
    @Published var errrorMessage: String? = nil
    var orderUseCase: OrderUseCase
    @Published var status: String? = nil

    var cancellables = Set<AnyCancellable>()

    init(orderUseCase: OrderUseCase) {
        self.orderUseCase = orderUseCase
    }

    func getOrder(orderStatus: OrderStatus, completion: (() -> Void)? = nil) {
        let parameter: [String: Any] = ["status": orderStatus.rawValue,
                                        "size": 100]
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

    func getOrderDetail(idOrder: String) {
        orderUseCase.getOrderDetail(idOrder: idOrder)
            .receive(on: RunLoop.main)
            .sink { [self] completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    errrorMessage = error.localizedDescription
                    print(error.localizedDescription)
                }
            } receiveValue: { orderResponse in
                self.orderDetailResponse = orderResponse
            }.store(in: &cancellables)
    }

    func patchOrderStatus(
        idOrder: String,
        newStatus: String,
        content: String? = nil,
        completion: ((Result<OrderResponse, Error>) -> Void)? = nil
    ) {
        orderUseCase.patchOrderStatus(idOrder: idOrder, newStatus: newStatus, content: content)
            .receive(on: RunLoop.main)
            .sink { completionResult in
                switch completionResult {
                case .finished:
                    break
                case let .failure(error):
                    completion?(.failure(error))
                }
            } receiveValue: { orderResponse in
                self.orderStatusResponse?.data?.removeAll { $0?.id == orderResponse.data?.id }

                completion?(.success(orderResponse))
            }
            .store(in: &cancellables)
    }

    func returnOrder(idOrder: String, reason: String, completion: ((Result<OrderResponse, Error>) -> Void)? = nil) {
        orderUseCase.returnOrder(idOrder: idOrder, reason: reason)
            .receive(on: RunLoop.main)
            .sink { completionResult in
                switch completionResult {
                case .finished:
                    break
                case let .failure(error):
                    completion?(.failure(error))
                }
            } receiveValue: { orderResponse in
                self.orderStatusResponse?.data?.removeAll { $0?.id == orderResponse.data?.id }

                completion?(.success(orderResponse))
            }
            .store(in: &cancellables)
    }
}
