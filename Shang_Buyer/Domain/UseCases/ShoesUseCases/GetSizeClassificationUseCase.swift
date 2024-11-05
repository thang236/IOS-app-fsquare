//
//  GetSizeClassificationUseCase.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 05/11/2024.
//

import Foundation
import Combine

protocol GetSizeClassificationUseCase {
    func execute(idClassification: String) -> AnyPublisher<SizesClassificationResponse, Error>
}

class GetSizeClassificationUsecaseImpl: GetSizeClassificationUseCase {
    private let sizesClassificationRepository: SizesClassificationRepository
    
    init(sizesClassificationRepository: SizesClassificationRepository) {
        self.sizesClassificationRepository = sizesClassificationRepository
    }
    
    func execute(idClassification: String) -> AnyPublisher<SizesClassificationResponse, Error> {
        return sizesClassificationRepository.getShoesSize(idClassification: idClassification)
    }
}
