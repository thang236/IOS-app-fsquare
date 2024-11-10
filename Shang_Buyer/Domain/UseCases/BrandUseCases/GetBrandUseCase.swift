//
//  GetBrandUseCase.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 11/10/2024.
//

import Combine
import Foundation

protocol GetBrandUseCase {
    func execute(parameter: [String: Any]) -> AnyPublisher<BrandResponse, Error>
}

class GetBrandUseCaseImpl: GetBrandUseCase {
    private let brandRepository: BrandRepository

    init(brandRepository: BrandRepository) {
        self.brandRepository = brandRepository
    }

    func execute(parameter: [String: Any]) -> AnyPublisher<BrandResponse, Error> {
        return brandRepository.getBrand(parameters: parameter)
    }
}
