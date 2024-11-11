//
//  GetAddressUseCase.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 10/11/2024.
//

import Combine
import Foundation

protocol GetAddressUseCase {
    func getAddress() -> AnyPublisher<AddressResponse, Error>
    func getProvinces() -> AnyPublisher<ProvincesResponse, Error>
    func getDistricts(provinceID: Int) -> AnyPublisher<DistrictsResponse, Error>
    func getWards(districtID: Int) -> AnyPublisher<WardsResponse, Error>
    func addLocation(parameter: [String: Any]) -> AnyPublisher<AddressResponse, Error>
    func editLocation(idLocation: String, parameter: [String: Any]) -> AnyPublisher<AddressResponse, Error>
    func deleteLocation(idLocation: String) -> AnyPublisher<AddressResponse, Error>
}

class GetAddressUseCaseImpl: GetAddressUseCase {
    private let addressRepository: AddressRepository

    init(addressRepository: AddressRepository) {
        self.addressRepository = addressRepository
    }

    func deleteLocation(idLocation: String) -> AnyPublisher<AddressResponse, Error> {
        addressRepository.deleteLocation(idLocation: idLocation)
    }

    func addLocation(parameter: [String: Any]) -> AnyPublisher<AddressResponse, Error> {
        addressRepository.addLocation(parameter: parameter)
    }

    func editLocation(idLocation: String, parameter: [String: Any]) -> AnyPublisher<AddressResponse, Error> {
        addressRepository.editLocation(idLocation: idLocation, parameter: parameter)
    }

    func getAddress() -> AnyPublisher<AddressResponse, Error> {
        addressRepository.getAddress()
    }

    func getProvinces() -> AnyPublisher<ProvincesResponse, Error> {
        addressRepository.getProvinces()
    }

    func getDistricts(provinceID: Int) -> AnyPublisher<DistrictsResponse, Error> {
        addressRepository.getDistricts(provinceID: provinceID)
    }

    func getWards(districtID: Int) -> AnyPublisher<WardsResponse, Error> {
        addressRepository.getWards(districtID: districtID)
    }
}
