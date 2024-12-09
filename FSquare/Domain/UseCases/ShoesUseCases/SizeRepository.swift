//
//  SizeRepository.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 05/11/2024.
//

import Combine
import Foundation

protocol SizeRepository {
    func getShoesSize(idSize: String) -> AnyPublisher<SizesClassificationResponse, Error>
}

class SizeRepositoryImpl: SizeRepository {
    private let sizeRepository: SizeRepository

    init(sizeRepository: SizeRepository) {
        self.sizeRepository = sizeRepository
    }

    func getShoesSize(idSize: String) -> AnyPublisher<SizesClassificationResponse, Error> {
        return sizeRepository.getShoesSize(idSize: idSize)
    }
}
