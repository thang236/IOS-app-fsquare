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

    @Published var bagResponse: BagResponse? = nil
    @Published var bagDeleteResponse: BagDeleteResponse? = nil
    @Published var bagPatchResponse: BagPatchResponse? = nil

    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    init(useCase: BagUseCase) {
        self.useCase = useCase
    }

    func getBag() {
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
