//
//  FavoriteViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 20/11/2024.
//

import UIKit

protocol FavoriteViewControllerDelegate: AnyObject {
    func didTapRemoveFavButton(favorite: FavoriteData)
}

class FavoriteViewController: UIViewController {
    var delegate: FavoriteViewControllerDelegate?
    var coordinator: HomeCoordinator?
    @IBOutlet private var collectionView: UICollectionView!
    private let viewModel: FavoriteViewModel
    private var searchBar: UISearchBar!

    init(viewModel: FavoriteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        setupCollectionView()
        viewModel.getFavoriteShoes()
        setupBindings()
    }

    override func viewWillAppear(_: Bool) {
        guard let tabBarItem = tabBarController?.tabBar else { return }
        tabBarItem.isHidden = true
    }

    override func viewWillDisappear(_: Bool) {
        guard let tabBarItem = tabBarController?.tabBar else { return }
        tabBarItem.isHidden = false
    }

    // MARK: - Setup Navigation

    private func setupNav() {
        navigationItem.hidesBackButton = true

        let image: UIImage = #imageLiteral(resourceName: "positionLeft")
        guard let size = navigationController?.navigationBar.frame.height else {
            return
        }
        let resizedImage = image.resizeImage(targetSize: CGSize(width: size, height: size))
        let backButton = UIBarButtonItem(image: resizedImage, style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = UIColor.neutralUltraDark

        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(didTapSearchButton))
        searchButton.tintColor = UIColor.neutralDark
        setupNavigationBar(leftBarButton: backButton, title: "My Favorite", rightBarButton: [searchButton])
    }

    @objc func didTapSearchButton() {
        navigationItem.rightBarButtonItems = nil
        navigationItem.leftBarButtonItems = nil
        searchBar = UISearchBar()
        searchBar.placeholder = "Search some shoes..."
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()

        navigationItem.titleView = searchBar
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        navigationItem.titleView = nil
        setupNav()
        viewModel.filterFavorites(by: "")
    }

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Setup CollectionView

    private func setupCollectionView() {
        collectionView.registerCell(cellType: FavoriteCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func setupBindings() {
        viewModel.$filteredFavorites
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &viewModel.cancellables)

        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                guard let wSelf = self else { return }
                wSelf.showToast(message: errorMessage, chooseImageToast: .warning)
            }.store(in: &viewModel.cancellables)

        viewModel.$successMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] successMessage in
                guard let wSelf = self else { return }
                wSelf.showToast(message: successMessage, chooseImageToast: .success)
            }.store(in: &viewModel.cancellables)
    }
}

extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return viewModel.filteredFavorites?.count ?? 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withType: FavoriteCollectionViewCell.self, for: indexPath)
        cell.setupCollectionView(favorite: viewModel.favorites?.data[indexPath.row])
        cell.delegate = self
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.frame.size.width / 2) - 32
        let height: CGFloat = 268
        return CGSize(width: width, height: height)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16)
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.goToShoesDetail(idShoes: viewModel.favorites?.data[indexPath.row].shoesId ?? "")
    }
}

extension FavoriteViewController: FavoriteCollectionViewCellDelegate {
    func didTapFavButton(favorite: FavoriteData) {
        viewModel.deleteFavoriteShoes(idFavorite: favorite.id, idShoes: favorite.shoesId)
        delegate?.didTapRemoveFavButton(favorite: favorite)
    }
}

extension FavoriteViewController: UISearchBarDelegate {
    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        viewModel.filterFavorites(by: searchText)
    }
}
