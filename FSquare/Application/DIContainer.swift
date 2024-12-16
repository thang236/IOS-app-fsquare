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
        let getAddressUseCase = resolveGetAddressUseCase()
        return LoadingViewModel(getProfileUseCase: getProfileUseCase, getAddressUseCase: getAddressUseCase)
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
        let getProfileUseCase = resolveGetProfileUseCase()
        return VerifyOTPViewModel(verifyOTPUseCase: verifyOTPUseCase, getProfileUseCase: getProfileUseCase)
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
        let editProfileUseCase = resolveEditProfileUseCase()
        return ProfileViewModel(getProfileUseCase: getProfileUseCase, editProfileUseCase: editProfileUseCase)
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

    func resolveClassificationsRepository() -> ClassificationRepository {
        let apiService = resolveAPIService()
        return ClassificationRepositoryImpl(apiService: apiService)
    }

    func resolveGetClassificationsUseCase() -> GetClassificationsUseCase {
        let classificationRepo = resolveClassificationsRepository()
        return GetClassificationsUseCaseImpl(classificationRepository: classificationRepo)
    }

    func resolveSizeClassificationRepository() -> SizeClassificationRepositoryImpl {
        let apiService = resolveAPIService()
        return SizeClassificationRepositoryImpl(apiService: apiService)
    }

    func resolveGetSizeClassificationUseCase() -> GetSizeClassificationUseCase {
        let sizeClassificationRepo = resolveSizeClassificationRepository()
        return GetSizeClassificationUsecaseImpl(sizesClassificationRepository: sizeClassificationRepo)
    }

    func resolveAddBagRepository() -> AddBagRepository {
        let apiService = resolveAPIService()
        return AddBagRepositoryImpl(apiService: apiService)
    }

    func resolveAddBagUseCase() -> AddBagUseCase {
        let addBagRepo = resolveAddBagRepository()
        return AddBagUseCaseImpl(addBagRepository: addBagRepo)
    }

    func resolveShoesDetailViewModel() -> ShoesDetailViewModel {
        let getShoesDetailUseCase = resolveGetShoesDetailUseCase()
        let getShoesClassificationUseCase = resolveGetShoesClassificationUseCase()
        let getClassificationUseCase = resolveGetClassificationsUseCase()
        let getSizeClassificationUseCase = resolveGetSizeClassificationUseCase()
        let addBagUseCase = resolveAddBagUseCase()
        let getShoesUseCase = resolveGetShoesUseCase()
        return ShoesDetailViewModel(
            getShoesDetailUseCase: getShoesDetailUseCase, getShoesClassificationUseCase: getShoesClassificationUseCase, getClassificationsUseCase: getClassificationUseCase, getSizeClassificationUseCase: getSizeClassificationUseCase, addBagUseCase: addBagUseCase,
            getShoesUseCase: getShoesUseCase
        )
    }

    // MARK: Cart

    func resolveCartRepository() -> BagRepository {
        let apiService = resolveAPIService()
        return BagRepositoryImpl(apiService: apiService)
    }

    func resolveCartUseCase() -> BagUseCase {
        let cartRepository = resolveCartRepository()
        return BagUseCaseImpl(repository: cartRepository)
    }

    func resolveOrderRepository() -> OrderRepository {
        let apiService = resolveAPIService()
        return OrderRepositoryImpl(apiService: apiService)
    }

    func resolveOrderUseCase() -> OrderUseCase {
        let orderRepository = resolveOrderRepository()
        return OrderUseCaseImpl(repository: orderRepository)
    }

    func resolveCartViewModel() -> CartViewModel {
        let cartUseCase = resolveCartUseCase()
        let getAddressUseCase = resolveGetAddressUseCase()
        let orderUseCase = resolveOrderUseCase()
        return CartViewModel(useCase: cartUseCase, getAddressUseCase: getAddressUseCase, orderUseCase: orderUseCase)
    }

    func resolveOrderViewModel() -> MyOrderViewModel {
        let orderUseCase = resolveOrderUseCase()
        return MyOrderViewModel(orderUseCase: orderUseCase)
    }

    func resolveNotificationRepository() -> NotificationRepository {
        let apiService = resolveAPIService()
        return NotificationRepositoryImpl(apiService: apiService)
    }

    func resolveNotificationUseCase() -> NotificationUseCase {
        let notificationRepository = resolveNotificationRepository()
        return NotificationUseCaseImpl(repository: notificationRepository)
    }

    func resolveNotificationViewModel() -> NotificationViewModel {
        let notificationUseCase = resolveNotificationUseCase()
        return NotificationViewModel(useCase: notificationUseCase)
    }
}
