//
//  CartViewModel.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 22/11/2024.
//

import Combine
import Foundation

class CartViewModel: ObservableObject {
    var cancellables = Set<AnyCancellable>()
    private let useCase: BagUseCase
    private let getAddressUseCase: GetAddressUseCase
    private let orderUseCase: OrderUseCase

    @Published var bagResponse: BagResponse? = nil
    @Published var bagDeleteResponse: BagDeleteResponse? = nil
    @Published var bagPatchResponse: BagPatchResponse? = nil
    @Published var addressResponse: AddressResponse? = nil
    @Published var addressChoose: AddressData? = nil
    @Published var feeResponse: FeeResponse? = nil
    @Published var postPaymentResponse: PostPaymentResponse? = nil

    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    @Published var orderResponse: OrderResponse? = nil

    init(useCase: BagUseCase, getAddressUseCase: GetAddressUseCase, orderUseCase: OrderUseCase) {
        self.useCase = useCase
        self.getAddressUseCase = getAddressUseCase
        self.orderUseCase = orderUseCase
    }

    func getBag(completion: (() -> Void)? = nil) {
        isLoading = true
        useCase.getBag()
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    self.isLoading = false
                case let .failure(error):
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { bagResponse in
                self.bagResponse = bagResponse
                completion?()
            }
            .store(in: &cancellables)
    }

    func removeBag(idBag: String) {
        isLoading = true
        useCase.removeBag(idBag: idBag)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    self.isLoading = false
                case let .failure(error):
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { _ in
                self.bagResponse?.data?.removeAll { $0.id == idBag }
            }
            .store(in: &cancellables)
    }

    func removeAllBag() {
        isLoading = true
        useCase.removeAllBag()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    self.isLoading = false
                    self.bagResponse?.data?.removeAll()

                case let .failure(error):
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { response in
                print(response)
            }
            .store(in: &cancellables)
    }

    func patchBag(idBag: String, quantity: Int, isDecrease: Bool = false) {
        var parameters: [String: Any] = ["action": "increase"]
        if isDecrease {
            parameters = ["action": "decrease"]
        }
        isLoading = true
        useCase.patchBag(idBag: idBag, parameters: parameters)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    self.isLoading = false
                    if let index = self.bagResponse?.data?.firstIndex(where: { $0.id == idBag }) {
                        self.bagResponse?.data?[index].quantity = quantity
                    }
                case let .failure(error):
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { response in
                print("Response: \(response)")
                self.bagPatchResponse = response
            }
            .store(in: &cancellables)
    }
}

// MARK: - CheckOut

extension CartViewModel {
    func postPayment(parameters: [String: Any]) {
        isLoading = true
        orderUseCase.postPayment(parameter: parameters)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    self.isLoading = false
                case let .failure(error):
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { postPaymentResponse in
                self.postPaymentResponse = postPaymentResponse
            }
            .store(in: &cancellables)
    }

    func createOrder(parameters: OrderRequest) {
        isLoading = true
        orderUseCase.createOrder(parameter: parameters)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    self.isLoading = false
                case let .failure(error):
                    self.errorMessage = error.localizedDescription
                    print("CreateOrderError:  \(error.localizedDescription)")
                }
            } receiveValue: { orderResponse in
                print("orderResponse: \(orderResponse)")
                self.orderResponse = orderResponse
            }.store(in: &cancellables)
    }

    func calculatorFee(parameters: [String: Any]) {
        isLoading = true
        orderUseCase.calculatorFee(parameter: parameters)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    self.isLoading = false
                case let .failure(error):
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { feeResponse in
                self.feeResponse = feeResponse
            }
            .store(in: &cancellables)
    }

    func getAddress() {
        isLoading = true
        getAddressUseCase.getAddress()
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    self.isLoading = false
                case let .failure(error):
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { addressResponse in
                self.addressResponse = addressResponse
                if addressResponse.data.isEmpty {
                    self.addressChoose = AddressData(id: "0", title: "Địa chỉ mặc định", address: "address.address", wardName: "address.wardName", districtName: "address.districtName", provinceName: "address.provinceName", isDefault: false)
                } else {
                    for address in addressResponse.data {
                        if address.isDefault == true {
                            self.addressChoose = address
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }

    func generateRandomID() -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let prefix = String((0 ..< 3).map { _ in letters.randomElement()! })
        let randomNumber = Int.random(in: 100_000 ... 999_999)
        return "FSORDER\(prefix)\(randomNumber)"
    }
}
