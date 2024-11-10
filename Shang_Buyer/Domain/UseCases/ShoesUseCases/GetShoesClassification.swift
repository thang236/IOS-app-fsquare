//
//  GetShoesClassification.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 05/11/2024.
//

import Combine
import Foundation

protocol GetShoesClassificationUseCase {
    func execute(idShoes: String) -> AnyPublisher<ShoesClassificationsResponse, Error>
}

class GetShoesClassificationUseCaseImpl: GetShoesClassificationUseCase {
    private let shoesClassificationRepository: ShoesClassificationRepository

    init(shoesClassificationRepository: ShoesClassificationRepository) {
        self.shoesClassificationRepository = shoesClassificationRepository
    }

    func execute(idShoes: String) -> AnyPublisher<ShoesClassificationsResponse, Error> {
        return shoesClassificationRepository.getShoesClassification(idShoes: idShoes)
    }
}
