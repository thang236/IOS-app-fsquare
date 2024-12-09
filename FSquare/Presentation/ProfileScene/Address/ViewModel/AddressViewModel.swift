//
//  AddressViewModel.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 08/10/2024.
//

import Combine
import Foundation

class AddressViewModel: ObservableObject {
    @Published var provinceID: Int? = nil
    @Published var districtID: Int? = nil
    @Published var wardID: Int? = nil
    @Published var provinces: ProvincesResponse? = nil
    @Published var districts: DistrictsResponse? = nil
    @Published var wards: WardsResponse? = nil
    @Published var address: AddressResponse? = nil
    @Published var errorMessage: String? = nil
    @Published var provinceName: String? = nil
    @Published var districtName: String? = nil
    @Published var wardName: String? = nil
    @Published var street: String? = nil

    var cancellables = Set<AnyCancellable>()
    private let getAddressUseCase: GetAddressUseCase

    init(getAddressUseCase: GetAddressUseCase) {
        self.getAddressUseCase = getAddressUseCase
    }

    func deleteLocation(idLocation: String, completion: @escaping (Result<AddressResponse, Error>) -> Void) {
        getAddressUseCase.deleteLocation(idLocation: idLocation)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(failure):
                    self.errorMessage = failure.localizedDescription
                }
            }, receiveValue: { addressResponse in
                completion(.success(addressResponse))
            }).store(in: &cancellables)
    }

    func addLocation(location: AddressData, completion: @escaping (Result<AddressResponse, Error>) -> Void) {
        let parameter = [
            "title": location.title,
            "address": location.address,
            "wardName": location.wardName,
            "districtName": location.districtName,
            "provinceName": location.provinceName,
        ]
        getAddressUseCase.addLocation(parameter: parameter)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(failure):
                    self.errorMessage = failure.localizedDescription
                }
            }, receiveValue: { response in
                completion(.success(response))
                self.provinceName = nil
                self.districtName = nil
                self.wardName = nil
                self.street = nil
            }).store(in: &cancellables)
    }

    func editLocation(location: AddressData, completion: @escaping (Result<AddressResponse, Error>) -> Void) {
        let parameter: [String: Any] = [
            "title": location.title,
            "address": location.address,
            "wardName": location.wardName,
            "districtName": location.districtName,
            "provinceName": location.provinceName,
            "isDefault": location.isDefault,
        ]
        getAddressUseCase.editLocation(idLocation: location.id, parameter: parameter)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(failure):
                    self.errorMessage = failure.localizedDescription
                }
            }, receiveValue: { response in
                completion(.success(response))
                self.provinceName = nil
                self.districtName = nil
                self.wardName = nil
                self.street = nil

            }).store(in: &cancellables)
    }

    func getProvinces() {
        getAddressUseCase.getProvinces()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(failure):
                    print(failure.localizedDescription)
                    self.errorMessage = failure.localizedDescription
                }
            } receiveValue: { provinces in
                self.provinces = provinces
            }
            .store(in: &cancellables)
    }

    func getDistricts() {
        guard let provinceId = provinceID else { return }
        getAddressUseCase.getDistricts(provinceID: provinceId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(failure):
                    self.errorMessage = failure.localizedDescription
                }
            } receiveValue: { districts in
                self.districts = districts
            }
            .store(in: &cancellables)
    }

    func getWards() {
        guard let districtId = districtID else { return }
        getAddressUseCase.getWards(districtID: districtId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(failure):
                    self.errorMessage = failure.localizedDescription
                    print("errorMessage: \(self.errorMessage)")
                }
            } receiveValue: { wards in
                print("wards: \(wards)")
                self.wards = wards
            }
            .store(in: &cancellables)
    }

    func getAddress() {
        getAddressUseCase.getAddress()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Completion: Success")
                case let .failure(failure):
                    self.errorMessage = failure.localizedDescription
                }
            } receiveValue: { address in
                self.address = address
            }
            .store(in: &cancellables)
    }
}
