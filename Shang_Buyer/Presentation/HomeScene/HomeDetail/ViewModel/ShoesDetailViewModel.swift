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
    @Published var shoesFavoriteID: String? = nil
    @Published var shoesDetail: ShoesDetailResponse? = nil
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var idShoes: String? = nil
    @Published var shoesClassification: ShoesClassificationsResponse? = nil
    @Published var classifications: ClassificationsResponse? = nil
    @Published var sizesClassification: SizesClassificationResponse? = nil
    @Published var quantity: Int? = nil
    @Published var idSize: String? = nil
    @Published var addBagResponse: AddBagResponse? = nil
    var cancellables = Set<AnyCancellable>()

    // MARK: - UseCase
    private let getShoesUseCase: GetShoesUseCase
    private let getShoesDetailUseCase: GetShoesDetailUseCase
    private let getShoesClassificationUseCase: GetShoesClassificationUseCase
    private let getClassificationsUseCase: GetClassificationsUseCase
    private let getSizeClassificationUseCase: GetSizeClassificationUseCase
    private let addBagUseCase: AddBagUseCase

    // MARK: - Init

    init(getShoesDetailUseCase: GetShoesDetailUseCase, getShoesClassificationUseCase: GetShoesClassificationUseCase, getClassificationsUseCase: GetClassificationsUseCase, getSizeClassificationUseCase: GetSizeClassificationUseCase, addBagUseCase: AddBagUseCase,
         getShoesUseCase: GetShoesUseCase) {
        self.getShoesDetailUseCase = getShoesDetailUseCase
        self.getShoesClassificationUseCase = getShoesClassificationUseCase
        self.getSizeClassificationUseCase = getSizeClassificationUseCase
        self.getClassificationsUseCase = getClassificationsUseCase
        self.addBagUseCase = addBagUseCase
        self.getShoesUseCase = getShoesUseCase
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

    func getClassificationAndSize(idClassification: String) {
        isLoading = true

        let classificationsPublisher = getClassificationsUseCase.execute(idClassification: idClassification)
        let sizesClassificationPublisher = getSizeClassificationUseCase.execute(idClassification: idClassification)

        Publishers.Zip(classificationsPublisher, sizesClassificationPublisher)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    break
                case let .failure(failure):
                    self.errorMessage = failure.localizedDescription
                    print("Error fetchData: \(self.errorMessage)")
                }
            }, receiveValue: { classifications, sizesClassification in
                self.classifications = classifications
                self.sizesClassification = sizesClassification
            })
            .store(in: &cancellables)
    }

    func addToBag(quantity: Int) {
        guard let idSize = idSize else {
            errorMessage = "Something is wrong"
            return
        }
        let parameter: [String: Any] = [
            "size": idSize,
            "quantity": quantity,
        ]
        addBagUseCase.execute(parameter: parameter)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(failure):
                    self.errorMessage = failure.localizedDescription
                    print("Error addBagUseCase: \(self.errorMessage)")
                }
            }, receiveValue: { response in
                self.addBagResponse = response
                print("Success addBagUseCase")
            }).store(in: &cancellables)
    }
    func toggleFav(isFav: Bool) {
        if isFav {
            removeFAV()
        } else {
            addFAV()
        }
    }
    
    private func addFAV() {
        guard let idShoes = idShoes else {
            errorMessage = "Something is wrong"
            return
        }
        let parameter: [String: Any] = [
            "shoes": idShoes,
        ]
        getShoesUseCase.addFavoriteShoes(parameter: parameter)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(failure):
                    self.errorMessage = failure.localizedDescription
                }
            }, receiveValue: { favoriteResponse in
                if favoriteResponse.status == HTTPStatus.created.message {
                    self.shoesDetail?.data?.isFavorite = true
                    SharedData.shared.idShoesAddFav = idShoes

                } else {
                    self.errorMessage = "\(favoriteResponse.status): \(favoriteResponse.message)"
                }
            }).store(in: &cancellables)
    }
    
    private func removeFAV() {
        guard let idShoes = idShoes else {
            errorMessage = "Something is wrong"
            return
        }
        let parameter: [String: Any] = [
            "shoes": idShoes,
        ]
        getShoesUseCase.removeFavoriteShoes(parameter: parameter)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(failure):
                    self.errorMessage = failure.localizedDescription
                }
            }, receiveValue: { favoriteResponse in
                if favoriteResponse.status == HTTPStatus.success.message {
                    self.shoesDetail?.data?.isFavorite = false
                    SharedData.shared.idShoesRemoveFav = idShoes
                } else {
                    self.errorMessage = "\(favoriteResponse.status): \(favoriteResponse.message)"
                }
            }).store(in: &cancellables)
    }
    
}
