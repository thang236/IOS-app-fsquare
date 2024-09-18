//
//  DIContainer.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 18/09/2024.
//

import Foundation

final class DIContainer {
    static let shared = DIContainer()

    private init() {}

    func resolveAPIService() -> APIService {
        return APIServiceImpl()
    }

    func resolveProductRepository() -> ProductRepository {
        let apiService = resolveAPIService()
        return ProductRepositoryImpl(apiService: apiService)
    }

    func resolveGetProductsUseCase() -> GetProductsUseCase {
        let productRepository = resolveProductRepository()
        return GetProductsUseCaseImpl(productRepository: productRepository)
    }

    func resolveProductListViewModel() -> ProductListViewModel {
        let getProductsUseCase = resolveGetProductsUseCase()
        return ProductListViewModel(getProductsUseCase: getProductsUseCase)
    }
}
