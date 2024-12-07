//
//  AddBagUseCase.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 22/11/2024.
//

import Combine
import Foundation

protocol AddBagUseCase {
    func execute(parameter: [String: Any]) -> AnyPublisher<AddBagResponse, Error>
}

class AddBagUseCaseImpl: AddBagUseCase {
    private let addBagRepository: AddBagRepository

    init(addBagRepository: AddBagRepository) {
        self.addBagRepository = addBagRepository
    }

    func execute(parameter: [String: Any]) -> AnyPublisher<AddBagResponse, Error> {
        return addBagRepository.addBag(parameter: parameter)
    }
}
