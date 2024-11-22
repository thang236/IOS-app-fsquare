//
//  FavoriteViewModel.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 20/11/2024.
//

import Combine
import Foundation

class FavoriteViewModel: ObservableObject {
    private let favoriteUseCase: FavoriteUseCase
    var cancellables = Set<AnyCancellable>()
    @Published var filteredFavorites: [FavoriteData]? = nil
    @Published var isLoading: Bool = true
    @Published var favorites: FavoriteResponse? = nil
    @Published var errorMessage: String? = nil
    @Published var successMessage: String? = nil

    init(favoriteUseCase: FavoriteUseCase) {
        self.favoriteUseCase = favoriteUseCase
    }

    func filterFavorites(by searchText: String) {
        guard let favorites = favorites?.data else { return }
        if searchText.isEmpty {
            filteredFavorites = favorites
        } else {
            filteredFavorites = favorites.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }

    func getFavoriteShoes() {
        favoriteUseCase.getFavoriteShoes()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    print("error GetFavorite: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { response in
                self.favorites = response
                self.filteredFavorites = response.data
                self.isLoading = false
            }
            .store(in: &cancellables)
    }

    func deleteFavoriteShoes(idFavorite: String, idShoes: String) {
        favoriteUseCase.deleteFavoriteShoes(idFavorite: idFavorite)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    self.successMessage = "Success delete favorite"
                    SharedData.shared.idShoesRemoveFav = idShoes
                case let .failure(error):
                    print("error DeleteFavorite: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { _ in
                self.favorites?.data.removeAll(where: { $0.id == idFavorite })
                self.isLoading = false
            }
            .store(in: &cancellables)
    }
}
