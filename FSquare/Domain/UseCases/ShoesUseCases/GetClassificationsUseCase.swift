//
//  GetClassificationsUseCase.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 05/11/2024.
//

import Combine
import Foundation

protocol GetClassificationsUseCase {
    func execute(idClassification: String) -> AnyPublisher<ClassificationsResponse, Error>
}

class GetClassificationsUseCaseImpl: GetClassificationsUseCase {
    private let classificationRepository: ClassificationRepository

    init(classificationRepository: ClassificationRepository) {
        self.classificationRepository = classificationRepository
    }

    func execute(idClassification: String) -> AnyPublisher<ClassificationsResponse, Error> {
        return classificationRepository.getClassification(idClassification: idClassification)
    }
}
