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
    
    //MARK: Detail shoes
    func resolveShoesDetailRepository() -> ShoesDetailRepository {
        let apiService = resolveAPIService()
        return ShoesDetailRepositoryImpl(apiService: apiService)
    }
    
    func resolveGetShoesDetailUseCase() -> GetShoesDetailUseCase {
        let shoesDetailRepo = resolveShoesDetailRepository()
        return GetShoesDetailUseCaseImpl(shoesDetailRepository: shoesDetailRepo)
    }
    
    func resolveShoesDetailViewModel() -> ShoesDetailViewModel {
        let getShoesDetailUseCase = resolveGetShoesDetailUseCase()
        return ShoesDetailViewModel(getShoesDetailUseCase: getShoesDetailUseCase)
    }
    
}
