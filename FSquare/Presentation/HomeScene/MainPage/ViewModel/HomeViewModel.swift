//
//  HomeViewModel.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 10/10/2024.
//

import Combine
import Foundation

class HomeViewModel: ObservableObject {
    @Published var historyResponse: HistoryResponse? = nil
    @Published var filterSearchResponse: ShoesResponse? = nil
    @Published var shoesResponse: ShoesResponse? = nil
    @Published var filterShoesResponse: ShoesResponse? = nil
    @Published var errorMessage: String? = nil
    @Published var successMessage: String? = nil
    @Published var brands: [BrandItem]? = nil
    @Published var brandLoading: Bool = true
    @Published var shoesLoading: Bool = true
    @Published var shoesFavoriteID: String? = nil
    @Published var hasNextPage: Bool = false
    @Published var page: Int = 1
    @Published var pageFlitterShoes: Int = 1
    @Published var popularResponse: PopularResponse? = nil
    var cancellables = Set<AnyCancellable>()

    let getShoesUseCase: GetShoesUseCase
    let getBrandUseCase: GetBrandUseCase

    init(getShoesUseCase: GetShoesUseCase, getBrandUseCase: GetBrandUseCase) {
        self.getShoesUseCase = getShoesUseCase
        self.getBrandUseCase = getBrandUseCase
        observeSharedData()
    }

    private func observeSharedData() {
        SharedData.shared.$idShoesRemoveFav
            .compactMap { $0 }
            .sink { [weak self] idShoesRemoveFav in
                guard let self = self else { return }
                print("idShoesRemoveFav  ", idShoesRemoveFav)
                for (index, shoes) in self.shoesResponse!.data.enumerated() {
                    if shoes.id == idShoesRemoveFav {
                        self.shoesResponse!.data[index].isFavorite = false
                        self.shoesFavoriteID = idShoesRemoveFav
                    }
                }
            }
            .store(in: &cancellables)

        SharedData.shared.$idShoesAddFav
            .compactMap { $0 }
            .sink { [weak self] idShoesAddFav in
                guard let self = self else { return }
                print("idShoesRemoveFav  ", idShoesAddFav)
                for (index, shoes) in self.shoesResponse!.data.enumerated() {
                    if shoes.id == idShoesAddFav {
                        self.shoesResponse!.data[index].isFavorite = true
                        self.shoesFavoriteID = idShoesAddFav
                    }
                }
            }
            .store(in: &cancellables)
    }

    func initDataSource() {
        page = 1
        fetchShoesAndBrands(page: page)
        getPopular()
    }

    private func getPopular() {
        getShoesUseCase.getPopularShoes()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(failure):
                    self.errorMessage = failure.localizedDescription
                }
            }, receiveValue: { popularResponse in
                if popularResponse.status == HTTPStatus.success.message {
                    self.popularResponse = popularResponse
                } else {
                    self.errorMessage = "\(popularResponse.status): \(popularResponse.message)"
                }
            }).store(in: &cancellables)
    }

    func filterSeeMore() {
        let parameter: [String: Any] = [
            "size": 40,
            "page": pageFlitterShoes,
            "search": "",
            "brand": "",
            "category": "",
        ]
        getShoesUseCase.execute(parameter: parameter)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.shoesLoading = false
                case let .failure(failure):
                    self.errorMessage = failure.localizedDescription
                }
            }, receiveValue: { shoesResponse in
                if shoesResponse.status == HTTPStatus.success.message {
                    self.filterShoesResponse = shoesResponse
                    if shoesResponse.options.hasNextPage {
                        self.pageFlitterShoes += 1
                        self.hasNextPage = true
                    } else {
                        self.hasNextPage = false
                    }
                } else {
                    self.errorMessage = "\(shoesResponse.status): \(shoesResponse.message)"
                }
            }).store(in: &cancellables)
    }

    func filterBand(idBrand: String) {
        let parameter: [String: Any] = [
            "size": 20,
            "page": pageFlitterShoes,
            "search": "",
            "brand": idBrand,
            "category": "",
        ]
        getShoesUseCase.execute(parameter: parameter)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.shoesLoading = false
                case let .failure(failure):
                    self.errorMessage = failure.localizedDescription
                }
            }, receiveValue: { shoesResponse in
                if shoesResponse.status == HTTPStatus.success.message {
                    self.filterShoesResponse = shoesResponse
                    if shoesResponse.options.hasNextPage {
                        self.pageFlitterShoes += 1
                        self.hasNextPage = true
                    } else {
                        self.hasNextPage = false
                    }
                } else {
                    self.errorMessage = "\(shoesResponse.status): \(shoesResponse.message)"
                }
            }).store(in: &cancellables)
    }

    func toggleFav(shoes: ShoeData) {
        guard let isFav = shoes.isFavorite else { return }
        if isFav {
            removeFAvHome(idShoes: shoes.id)
        } else {
            addFAvHome(idShoes: shoes.id)
        }
    }

    private func removeFAvHome(idShoes: String) {
        let parameter: [String: Any] = [
            "shoes": idShoes,
        ]
        getShoesUseCase.removeFavoriteShoes(parameter: parameter)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.successMessage = "Success remove favorite shoes"
                case let .failure(failure):
                    print("ErrorremoveFavoriteShoes: \(failure.localizedDescription)")
                    self.errorMessage = failure.localizedDescription
                }
            }, receiveValue: { favoriteResponse in
                if favoriteResponse.status == HTTPStatus.success.message {
                    for (index, shoes) in self.shoesResponse!.data.enumerated() {
                        if shoes.id == idShoes {
                            self.shoesResponse!.data[index].isFavorite = false
                            self.shoesFavoriteID = idShoes
                        }
                    }

                    if let filterShoesData = self.filterShoesResponse?.data {
                        for (index, shoes) in filterShoesData.enumerated() {
                            if shoes.id == idShoes {
                                self.filterShoesResponse!.data[index].isFavorite = false
                            }
                        }
                    }
                    if let filterSearchData = self.filterSearchResponse?.data {
                        for (index, shoes) in filterSearchData.enumerated() {
                            if shoes.id == idShoes {
                                self.filterSearchResponse!.data[index].isFavorite = false
                            }
                        }
                    }

                } else { self.errorMessage = "\(favoriteResponse.status): \(favoriteResponse.message)" }
            }).store(in: &cancellables)
    }

    private func addFAvHome(idShoes: String) {
        let parameter: [String: Any] = [
            "shoes": idShoes,
        ]
        getShoesUseCase.addFavoriteShoes(parameter: parameter)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.successMessage = "Success add favorite shoes"
                case let .failure(failure):
                    print("Error addFavoriteShoes: \(failure.localizedDescription)")

                    self.errorMessage = failure.localizedDescription
                }
            }, receiveValue: { favoriteResponse in
                if favoriteResponse.status == HTTPStatus.created.message {
                    for (index, shoes) in self.shoesResponse!.data.enumerated() {
                        if shoes.id == idShoes {
                            self.shoesResponse!.data[index].isFavorite = true
                            self.shoesFavoriteID = idShoes
                        }
                    }
                    if let filterShoesData = self.filterShoesResponse?.data {
                        for (index, shoes) in filterShoesData.enumerated() {
                            if shoes.id == idShoes {
                                self.filterShoesResponse!.data[index].isFavorite = true
                            }
                        }
                    }
                    if let filterSearchData = self.filterSearchResponse?.data {
                        for (index, shoes) in filterSearchData.enumerated() {
                            if shoes.id == idShoes {
                                self.filterSearchResponse!.data[index].isFavorite = true
                            }
                        }
                    }

                } else { self.errorMessage = "\(favoriteResponse.status): \(favoriteResponse.message)" }
            }).store(in: &cancellables)
    }

    func getMoreShoes() {
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
                    self.shoesResponse?.data.append(contentsOf: shoesResponse.data)
                    if shoesResponse.options.hasNextPage {
                        self.page += 1
                        self.hasNextPage = true
                    } else {
                        self.hasNextPage = false
                    }
                    self.shoesLoading = false

                } else {
                    self.errorMessage = "\(shoesResponse.status): \(shoesResponse.message)"
                }
            }).store(in: &cancellables)
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
                    self.shoesLoading = false
                case let .failure(failure):
                    self.errorMessage = failure.localizedDescription
                }
            }, receiveValue: { shoesResponse in
                if shoesResponse.status == HTTPStatus.success.message {
                    self.shoesResponse = shoesResponse
                    if shoesResponse.options.hasNextPage {
                        self.page += 1
                        self.hasNextPage = true
                    } else {
                        self.hasNextPage = false
                    }
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
                switch result {
                case .finished:
                    self.brandLoading = false
                case let .failure(failure):
                    print("Error getBrand: \(failure.localizedDescription)")
                    self.errorMessage = failure.localizedDescription
                }
            }, receiveValue: { brandResponse in
                self.brands = brandResponse.data
                let thumnail = Thumbnail(url: "more")
                if brandResponse.data.count == 7 {
                    self.brands?.append(BrandItem(id: "0", name: "Xem thêm", thumbnail: thumnail))
                }
            }).store(in: &cancellables)
    }

    func fetchShoesAndBrands(page: Int) {
        let shoesParameter: [String: Any] = [
            "size": 10,
            "page": page,
            "search": "",
            "brand": "",
            "category": "",
        ]

        let brandParameter: [String: Any] = [
            "size": 7,
            "page": 1,
            "search": "",
        ]

        let shoesPublisher = getShoesUseCase.execute(parameter: shoesParameter)
        let brandPublisher = getBrandUseCase.execute(parameter: brandParameter)

        Publishers.CombineLatest(shoesPublisher, brandPublisher)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.shoesLoading = false
                    self.brandLoading = false
                case let .failure(error):
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { shoesResponse, brandResponse in
                if shoesResponse.status == HTTPStatus.success.message {
                    self.shoesResponse = shoesResponse
                    if shoesResponse.options.hasNextPage {
                        self.page += 1
                        self.hasNextPage = true
                    } else {
                        self.hasNextPage = false
                    }
                } else {
                    self.errorMessage = "\(shoesResponse.status): \(shoesResponse.message)"
                }
                self.brands = brandResponse.data
                let thumnail = Thumbnail(url: "more")
                if brandResponse.data.count == 7 {
                    self.brands?.append(BrandItem(id: "0", name: "Xem thêm", thumbnail: thumnail))
                }
            }).store(in: &cancellables)
    }
}

extension HomeViewModel {
    func deleteHistory(idHistory: String) {
        getShoesUseCase.deleteHistory(idHistory: idHistory)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(failure):
                    self.errorMessage = failure.localizedDescription
                }
            } receiveValue: { deleteHistoryResponse in
                if deleteHistoryResponse.status == HTTPStatus.success.message {
                    self.historyResponse?.data.removeAll { $0?.id == idHistory }
                } else {
                    self.errorMessage = "\(deleteHistoryResponse.status): \(deleteHistoryResponse.message)"
                }
            }.store(in: &cancellables)
    }

    func postHistory(keyWord: String) {
        getShoesUseCase.postHistory(keyWord: keyWord)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(failure):
                    self.errorMessage = failure.localizedDescription
                }
            } receiveValue: { historyResponse in
                if historyResponse.status == HTTPStatus.created.message {
                    self.historyResponse?.data.append(historyResponse.data)
                } else {
                    self.errorMessage = "\(historyResponse.status): \(historyResponse.message)"
                }
            }.store(in: &cancellables)
    }

    func getHistory() {
        getShoesUseCase.getHistory()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(failure):
                    self.errorMessage = failure.localizedDescription
                }
            }, receiveValue: { historyResponse in
                if historyResponse.status == HTTPStatus.success.message {
                    self.historyResponse = historyResponse
                } else {
                    self.errorMessage = "\(historyResponse.status): \(historyResponse.message)"
                }
            }).store(in: &cancellables)
    }

    func searchShoes(search: String, idBrand: String = "", idCategory: String = "") {
        let shoesParameter: [String: Any] = [
            "size": 40,
            "page": 1,
            "search": search,
            "brand": idBrand,
            "category": idCategory,
        ]
        getShoesUseCase.execute(parameter: shoesParameter)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.shoesLoading = false
                case let .failure(failure):
                    self.errorMessage = failure.localizedDescription
                }
            }, receiveValue: { shoesResponse in
                if shoesResponse.status == HTTPStatus.success.message {
                    self.filterSearchResponse = shoesResponse
                } else {
                    self.errorMessage = "\(shoesResponse.status): \(shoesResponse.message)"
                }
            }).store(in: &cancellables)
    }
}
