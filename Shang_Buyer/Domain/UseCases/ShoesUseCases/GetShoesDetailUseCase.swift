//
//  GetShoesDetailUseCase.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 04/11/2024.
//

import Combine
import Foundation

protocol GetShoesDetailUseCase {
    func execute(idShoes: String) -> AnyPublisher<ShoesDetailResponse, Error>
}

class GetShoesDetailUseCaseImpl: GetShoesDetailUseCase {
    private let shoesDetailRepository: ShoesDetailRepository

    init(shoesDetailRepository: ShoesDetailRepository) {
        self.shoesDetailRepository = shoesDetailRepository
    }

    func execute(idShoes: String) -> AnyPublisher<ShoesDetailResponse, Error> {
        return shoesDetailRepository.getShoesDetail(idShoes: idShoes)
    }
}
