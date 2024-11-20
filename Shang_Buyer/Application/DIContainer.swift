//
//  DIContainer.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 18/09/2024.
//

import Foundation

final class DIContainer {
    static let shared = DIContainer()

    private init() {}

    // MARK: API Service

    func resolveAPIService() -> APIService {
        return APIServiceImpl()
    }

    // MARK: get

    func resolveProductRepository() -> ProductRepository {
        let apiService = resolveAPIService()
        return ProductRepositoryImpl(apiService: apiService)
    }

    func resolveGetProductsUseCase() -> GetProductsUseCase {
        let productRepository = resolveProductRepository()
        return GetProductsUseCaseImpl(productRepository: productRepository)
    }

    // MARK: Auth Service

    func resolveAuthService() -> AuthService {
        return AuthServiceImpl()
    }

    func resolveAuthRepository() -> AuthRepository {
        let authService = resolveAuthService()
        return AuthRepositoryImpl(authService: authService)
    }

    // MARK: Login

    func resolveLoginEmailUseCase() -> LoginEmailUseCase {
        let authRepository = resolveAuthRepository()
        return LoginEmailUseCaseImpl(authRepository: authRepository)
    }

    func resolveLoadingViewModel() -> LoadingViewModel {
        let getProfileUseCase = resolveGetProfileUseCase()
        return LoadingViewModel(getProfileUseCase: getProfileUseCase)
    }

    func resolveLoginEmailViewModel() -> LoginWithEmailViewModel {
        let loginUseCase = resolveLoginEmailUseCase()
        return LoginWithEmailViewModel(loginEmailUseCase: loginUseCase)
    }

    func resolveRegisterUseCase() -> RegisterUseCase {
        let authRepository = resolveAuthRepository()
        return RegisterUseCaseImpl(authRepository: authRepository)
    }

    func resolveRegisterViewModel() -> RegisterViewModel {
        let registerUseCase = resolveRegisterUseCase()
        return RegisterViewModel(registerUseCase: registerUseCase)
    }

    func resolveVerifyOTPUseCase() -> VerifyOTPUseCase {
        let authRepository = resolveAuthRepository()
        return VerifyOTPUseCaseImpl(authRepository: authRepository)
    }

    func resolveVerifyAthViewModel() -> VerifyOTPViewModel {
        let verifyOTPUseCase = resolveVerifyOTPUseCase()
        return VerifyOTPViewModel(verifyOTPUseCase: verifyOTPUseCase)
    }

    // MARK: Profile

    func resolveProfileRepository() -> ProfileRepository {
        let apiService = resolveAPIService()
        return ProfileRepositoryImpl(apiService: apiService)
    }

    func resolveGetProfileUseCase() -> GetProfileUseCase {
        let profileRepo = resolveProfileRepository()
        return GetProfileUseCaseImpl(profileRepository: profileRepo)
    }

    func resolveProfileViewModel() -> ProfileViewModel {
        let getProfileUseCase = resolveGetProfileUseCase()
        return ProfileViewModel(getProfileUseCase: getProfileUseCase)
    }

    func resolveEditProfileUseCase() -> EditProfileUseCase {
        let profileRepo = resolveProfileRepository()
        return EditProfileUseCaseImpl(profileRepository: profileRepo)
    }

    func resolveEditProfileViewModel() -> EditProfileViewModel {
        let editProfileUseCase = resolveEditProfileUseCase()
        return EditProfileViewModel(editProfileUseCase: editProfileUseCase)
    }

    func resolveAddressRepository() -> AddressRepository {
        let apiService = resolveAPIService()
        return AddressRepositoryImpl(apiService: apiService)
    }

    func resolveGetAddressUseCase() -> GetAddressUseCase {
        let addressRepository = resolveAddressRepository()
        return GetAddressUseCaseImpl(addressRepository: addressRepository)
    }

    func resolveAddressViewModel() -> AddressViewModel {
        let getAddressUseCase = resolveGetAddressUseCase()
        return AddressViewModel(getAddressUseCase: getAddressUseCase)
    }

    // MARK: Main page

    func resolveShoesRepository() -> ShoesRepository {
        let apiService = resolveAPIService()
        return ShoesRepositoryImpl(apiService: apiService)
    }

    func resolveGetShoesUseCase() -> GetShoesUseCase {
        let shoesRepo = resolveShoesRepository()
        return GetShoesUseCaseImpl(shoesRepository: shoesRepo)
    }

    func resolveBrandRepository() -> BrandRepository {
        let apiService = resolveAPIService()
        return BrandRepositoryImpl(apiService: apiService)
    }

    func resolveGetBrandUseCase() -> GetBrandUseCase {
        let brandRepo = resolveBrandRepository()
        return GetBrandUseCaseImpl(brandRepository: brandRepo)
    }

    func resolveHomeViewModel() -> HomeViewModel {
        let getShoesUseCase = resolveGetShoesUseCase()
        let getBrandUseCase = resolveGetBrandUseCase()
        return HomeViewModel(getShoesUseCase: getShoesUseCase, getBrandUseCase: getBrandUseCase)
    }

    func resolveFavoriteRepository() -> FavoriteRepository {
        let apiService = resolveAPIService()
        return FavoriteRepositoryImpl(apiService: apiService)
    }

    func resolveFavoriteUseCase() -> FavoriteUseCase {
        let favoriteRepo = resolveFavoriteRepository()
        return FavoriteUseCaseImpl(favoriteRepository: favoriteRepo)
    }

    func resolveFavoriteViewModel() -> FavoriteViewModel {
        let favoriteUseCase = resolveFavoriteUseCase()
        return FavoriteViewModel(favoriteUseCase: favoriteUseCase)
    }

    // MARK: Detail shoes

    func resolveShoesDetailRepository() -> ShoesDetailRepository {
        let apiService = resolveAPIService()
        return ShoesDetailRepositoryImpl(apiService: apiService)
    }

    func resolveGetShoesDetailUseCase() -> GetShoesDetailUseCase {
        let shoesDetailRepo = resolveShoesDetailRepository()
        return GetShoesDetailUseCaseImpl(shoesDetailRepository: shoesDetailRepo)
    }

    func resolveShoesClassificationRepository() -> ShoesClassificationRepository {
        let apiService = resolveAPIService()
        return ShoesClassificationsRepositoryImpl(apiService: apiService)
    }

    func resolveGetShoesClassificationUseCase() -> GetShoesClassificationUseCase {
        let shoesClassificationRepo = resolveShoesClassificationRepository()
        return GetShoesClassificationUseCaseImpl(shoesClassificationRepository: shoesClassificationRepo)
    }

    func resolveShoesDetailViewModel() -> ShoesDetailViewModel {
        let getShoesDetailUseCase = resolveGetShoesDetailUseCase()
        let getShoesClassificationUseCase = resolveGetShoesClassificationUseCase()
        return ShoesDetailViewModel(getShoesDetailUseCase: getShoesDetailUseCase, getShoesClassificationUseCase: getShoesClassificationUseCase)
    }
}
