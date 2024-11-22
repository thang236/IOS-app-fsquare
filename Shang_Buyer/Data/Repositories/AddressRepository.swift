//
//  AddressRepository.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 10/11/2024.
//

import Combine
import Foundation

protocol AddressRepository {
    func getProvinces() -> AnyPublisher<ProvincesResponse, Error>
    func getDistricts(provinceID: Int) -> AnyPublisher<DistrictsResponse, Error>
    func getWards(districtID: Int) -> AnyPublisher<WardsResponse, Error>
    func getAddress() -> AnyPublisher<AddressResponse, Error>
    func addLocation(parameter: [String: Any]) -> AnyPublisher<AddressResponse, Error>
    func editLocation(idLocation: String, parameter: [String: Any]) -> AnyPublisher<AddressResponse, Error>
    func deleteLocation(idLocation: String) -> AnyPublisher<AddressResponse, Error>
}

class AddressRepositoryImpl: AddressRepository {
    private let apiService: APIService

    init(apiService: APIService) {
        self.apiService = apiService
    }

    func addLocation(parameter: [String: Any]) -> AnyPublisher<AddressResponse, Error> {
        apiService.request(endpoint: .postLocation, method: .post, parameters: parameter)
    }

    func editLocation(idLocation: String, parameter: [String: Any]) -> AnyPublisher<AddressResponse, Error> {
        apiService.request(endpoint: .editLocation(idLocation: idLocation), method: .patch, parameters: parameter)
    }

    func deleteLocation(idLocation: String) -> AnyPublisher<AddressResponse, Error> {
        apiService.request(endpoint: .deleteLocation(idLocation: idLocation), method: .delete, parameters: nil)
    }

    func getAddress() -> AnyPublisher<AddressResponse, Error> {
        apiService.request(endpoint: .getAddress, method: .get, parameters: nil)
    }

    func getProvinces() -> AnyPublisher<ProvincesResponse, Error> {
        apiService.request(endpoint: .getProvinces, method: .get, parameters: nil)
    }

    func getDistricts(provinceID: Int) -> AnyPublisher<DistrictsResponse, Error> {
        apiService.request(endpoint: .getDistricts(idProvince: provinceID), method: .get, parameters: nil)
    }

    func getWards(districtID: Int) -> AnyPublisher<WardsResponse, Error> {
        apiService.request(endpoint: .getWards(idDistrict: districtID), method: .get, parameters: nil)
    }
}
