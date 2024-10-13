//
//  GetShoesUseCase.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 09/10/2024.
//

import Combine
import Foundation

protocol GetShoesUseCase {
    func execute(parameter: [String: Any]) -> AnyPublisher<ShoesResponse, Error>
}

class GetShoesUseCaseImpl: GetShoesUseCase {
    private let shoesRepository: ShoesRepository

    init(shoesRepository: ShoesRepository) {
        self.shoesRepository = shoesRepository
    }

    func execute(parameter: [String: Any]) -> AnyPublisher<ShoesResponse, Error> {
        return shoesRepository.getShoes(parameters: parameter)
    }
}
