//
//  HomeCoordinator.swift
//  CombineMVVMUIKitExample
//
//  Created by Louis Macbook on 11/09/2024.
//

import Foundation
import UIKit

class HomeCoordinator: Coordinator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
//        let postService = PostService()
//        let postRepository = PostRepository(postService: postService)
//        let getPostsUseCase = GetPostsUseCase(postRepository: postRepository)
//        let viewModel = PostListViewModel(getPostsUseCase: getPostsUseCase)
        let apiService = APIServiceImpl()
        let productRepository = ProductRepositoryImpl(apiService: apiService)
        let getProductUseCase = GetProductsUseCaseImpl(productRepository: productRepository)
        let productLisViewModel = ProductListViewModel(getProductsUseCase: getProductUseCase)
        let viewController = ProductListViewController(viewModel: productLisViewModel)
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
//    func showDetail() {
//        let detailViewController = DetailViewController()
//        navigationController.pushViewController(detailViewController, animated: true)
//    }
}
