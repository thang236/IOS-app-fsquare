//
//  HomeViewModel.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 10/10/2024.
//

import Combine
import Foundation

class HomeViewModel: ObservableObject {
    @Published var shoesResponse: ShoesResponse? = nil
    @Published var errorMessage: String? = nil
    @Published var brands: [BrandItem] = []
    var cancellables = Set<AnyCancellable>()

    let getShoesUseCase: GetShoesUseCase
    let getBrandUseCase: GetBrandUseCase

    init(getShoesUseCase: GetShoesUseCase, getBrandUseCase: GetBrandUseCase) {
        self.getShoesUseCase = getShoesUseCase
        self.getBrandUseCase = getBrandUseCase
    }

    func getShoes(page: Int) {
        let parameter: [String: Any] = [
            "size": 10,
            "page": page,
            "search": "",
            "brand": "",
            "category": "",
        ]
        getShoesUseCase.execute(parameter: parameter)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(failure):
                    self.errorMessage = failure.localizedDescription
                }
            }, receiveValue: { shoesResponse in
                if shoesResponse.status == HTTPStatus.success.message {
                    self.shoesResponse = shoesResponse
                } else {
                    self.errorMessage = "\(shoesResponse.status): \(shoesResponse.message)"
                }
            }).store(in: &cancellables)
    }

    func getBrand() {
        let parameter: [String: Any] = [
            "size": 7,
            "page": 1,
            "search": "",
        ]
        getBrandUseCase.execute(parameter: parameter)
            .sink(receiveCompletion: { result in
                print(result)
                switch result {
                case .finished:
                    break
                case let .failure(failure):
                    self.errorMessage = failure.localizedDescription
                }
            }, receiveValue: { brandResponse in
                self.brands = brandResponse.data
            }).store(in: &cancellables)
    }
}
