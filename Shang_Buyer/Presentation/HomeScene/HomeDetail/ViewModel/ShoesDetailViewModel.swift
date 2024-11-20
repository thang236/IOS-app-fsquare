//
//  ShoesDetailViewModel.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 30/10/2024.
//

import Combine
import Foundation

class ShoesDetailViewModel: ObservableObject {
    // MARK: - Properties

    @Published var shoesDetail: ShoesDetailResponse? = nil
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var idShoes: String? = nil
    @Published var shoesClassification: ShoesClassificationsResponse? = nil
    var cancellables = Set<AnyCancellable>()

    // MARK: - UseCase

    private let getShoesDetailUseCase: GetShoesDetailUseCase
    private let getShoesClassificationUseCase: GetShoesClassificationUseCase

    // MARK: - Init

    init(getShoesDetailUseCase: GetShoesDetailUseCase, getShoesClassificationUseCase: GetShoesClassificationUseCase) {
        self.getShoesDetailUseCase = getShoesDetailUseCase
        self.getShoesClassificationUseCase = getShoesClassificationUseCase
    }

    // MARK: - Function

    func initDataSource(idShoes: String) {
        self.idShoes = idShoes
        getShoesClassification()
        getShoesDetail()
    }

    func getShoesDetail() {
        guard let idShoes = idShoes else {
            errorMessage = "Something is wrong"
            return
        }
        isLoading = true
        getShoesDetailUseCase.execute(idShoes: idShoes)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    print("Completion: Success")
                case let .failure(failure):
                    self.errorMessage = failure.localizedDescription
                    print("Error getShoesDetail: \(self.errorMessage)")
                }
            }, receiveValue: { shoesDetail in
                self.shoesDetail = shoesDetail
            }).store(in: &cancellables)
    }

    func getShoesClassification() {
        guard let idShoes = idShoes else {
            errorMessage = "Something is wrong"
            return
        }
        isLoading = true
        getShoesClassificationUseCase.execute(idShoes: idShoes)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(failure):
                    self.errorMessage = failure.localizedDescription
                    print(self.errorMessage)
                    print("Error getShoesClassification: \(self.errorMessage)")
                }
            }, receiveValue: { shoesClassification in
                self.isLoading = false
                self.shoesClassification = shoesClassification
            }).store(in: &cancellables)
    }
}
