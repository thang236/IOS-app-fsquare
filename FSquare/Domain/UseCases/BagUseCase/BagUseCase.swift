//
//  BagUseCase.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 22/11/2024.
//

import Combine
import Foundation

protocol BagUseCase {
    func getBag() -> AnyPublisher<BagResponse, Error>
    func removeBag(idBag: String) -> AnyPublisher<BagDeleteResponse, Error>
    func removeAllBag() -> AnyPublisher<BagDeleteResponse, Error>
    func patchBag(idBag: String, parameters: [String: Any]) -> AnyPublisher<BagPatchResponse, Error>
}

class BagUseCaseImpl: BagUseCase {
    private let repository: BagRepository

    init(repository: BagRepository) {
        self.repository = repository
    }

    func getBag() -> AnyPublisher<BagResponse, Error> {
        repository.getBag()
    }

    func removeBag(idBag: String) -> AnyPublisher<BagDeleteResponse, Error> {
        repository.removeBag(idBag: idBag)
    }

    func removeAllBag() -> AnyPublisher<BagDeleteResponse, Error> {
        repository.removeAllBag()
    }

    func patchBag(idBag: String, parameters: [String: Any]) -> AnyPublisher<BagPatchResponse, Error> {
        repository.patchBag(idBag: idBag, parameters: parameters)
    }
}
