//
//  HomeViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 02/10/2024.
//

import Combine
import SkeletonView
import UIKit

enum HomeCollectionType: String, CaseIterable, Hashable {
    case banner
    case popular
    case brand
    case shoes
    var title: String {
        switch self {
        case .popular:
            return "Popular"
        case .brand:
            return "Brand"
        case .shoes:
            return "Newest shoes"
        case .banner:
            return "Banner"
        }
    }
}

enum HomeCollectionContentCell: Hashable {
    case popular(id: String, title: String, price: Double)
    case brand(id: String, url: String?, nameBrand: String)
    case shoes(shoes: ShoeData)
    case banner
}

class HomeViewController: UIViewController {
    // MARK: - @IBOutlet

    @IBOutlet var collectionView: UICollectionView!

    // MARK: - Properties

    private var viewModel: HomeViewModel
    var coordinator: HomeCoordinator?

    private lazy var dataSource:
        UICollectionViewDiffableDataSource<HomeCollectionType, HomeCollectionContentCell> = {
            let dataSource = UICollectionViewDiffableDataSource<HomeCollectionType, HomeCollectionContentCell>(collectionView: self.collectionView) { [weak self] collectionView, indexPath, item in
                guard let wSelf = self else {
                    return UICollectionViewCell()
                }

                switch item {
                case .banner:
                    let cell = collectionView.dequeueReusableCell(withType: BannerHomeCollectionViewCell.self, for: indexPath)
                    return cell
                case let .popular(id, title, price):
                    let cell = collectionView.dequeueReusableCell(withType: PopularCollectionViewCell.self, for: indexPath)
                    cell.setupCell(title: title, price: NumberFormatter.formatToVNDWithCustomSymbol(price))
                    return cell
                case let .brand(id, url, nameBrand):
                    let cell = collectionView.dequeueReusableCell(withType: BrandCollectionViewCell.self, for: indexPath)
                    cell.setupBrandCollectionView(url: url, nameBrand: nameBrand)

                    return cell
                case let .shoes(shoes):
                    let cell = collectionView.dequeueReusableCell(withType: ProductCollectionViewCell.self, for: indexPath)
                    cell.setupCollectionView(shoes: shoes)
                    cell.delegate = wSelf

                    return cell
                }
            }

            dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
                let section = HomeCollectionType.allCases[indexPath.section]
                if kind == UICollectionView.elementKindSectionHeader {
                    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderHomeCollectionReusableView.reuseIdentifier, for: indexPath) as? HeaderHomeCollectionReusableView
                    header?.configure(homeCollectionType: section)
                    header?.delegate = self
                    switch section {
                    case .banner:
                        return nil
                    case .popular:
                        return header
                    case .brand:
                        return nil
                    case .shoes:
                        return header
                    }
                }

                if kind == UICollectionView.elementKindSectionFooter {
                    let loadingView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LoadingCollectionReusableView", for: indexPath)
                    return loadingView
                }

                return nil
            }

            return dataSource
        }()

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.initDataSource()
        setupCollectionView()
        setupNavigationBar()
        setupBinding()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .primaryDark
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.standardAppearance = appearance
        }
    }

    override func viewWillDisappear(_: Bool) {
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .clear
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.standardAppearance = appearance
        }
    }

    // MARK: - Setup layout

    private func setupNavigationBar() {
        let image = UIImage.logoBanner
        let logoButton = UIBarButtonItem(image: image.withRenderingMode(.alwaysOriginal), style: .done, target: nil, action: nil)
        navigationItem.leftBarButtonItem = logoButton

        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(didTapSearchButton))
        searchButton.tintColor = UIColor.white

        let favoriteButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(didTapFavorite))
        favoriteButton.tintColor = UIColor.white
        navigationItem.rightBarButtonItems = [favoriteButton, searchButton]
    }

    private func setupCollectionView() {
        collectionView.registerCell(cellType: PopularCollectionViewCell.self)
        collectionView.registerCell(cellType: BrandCollectionViewCell.self)
        collectionView.registerCell(cellType: ProductCollectionViewCell.self)
        collectionView.registerCell(cellType: BannerHomeCollectionViewCell.self)
        collectionView.register(HeaderHomeCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderHomeCollectionReusableView.reuseIdentifier)
        let loadingReusableNib = UINib(nibName: "LoadingCollectionReusableView", bundle: nil)
        collectionView.register(loadingReusableNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "LoadingCollectionReusableView")

        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.collectionViewLayout = createLayout()

        var snapshot = NSDiffableDataSourceSnapshot<HomeCollectionType, HomeCollectionContentCell>()
        snapshot.appendSections(HomeCollectionType.allCases)
        snapshot.appendItems([.banner], toSection: .banner)
        snapshot.appendItems([
            .popular(id: "", title: "", price: -1),
            .popular(id: "1", title: "", price: -1),
        ], toSection: .popular)
        snapshot.appendItems([
            .shoes(shoes: ShoeData(id: "", name: "", thumbnail: nil, minPrice: -1, maxPrice: -1, rating: 0, reviewCount: 0, isFavorite: false, sales: 0)),
            .shoes(shoes: ShoeData(id: "1", name: "", thumbnail: nil, minPrice: -1, maxPrice: -1, rating: 0, reviewCount: 0, isFavorite: false, sales: 0)),
        ], toSection: .shoes)
        snapshot.appendItems([
            .brand(id: "1", url: nil, nameBrand: ""),
            .brand(id: "2", url: nil, nameBrand: ""),
            .brand(id: "3", url: nil, nameBrand: ""),
            .brand(id: "4", url: nil, nameBrand: ""),
            .brand(id: "5", url: nil, nameBrand: ""),
            .brand(id: "6", url: nil, nameBrand: ""),
            .brand(id: "7", url: nil, nameBrand: ""),
            .brand(id: "8", url: nil, nameBrand: ""),
        ], toSection: .brand)

        dataSource.apply(snapshot, animatingDifferences: false)
    }

    // MARK: - Setup binding

    private func setupBinding() {
        viewModel.$shoesResponse
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                guard let wSelf = self else { return }
                var snapshot = wSelf.dataSource.snapshot()
                if let response = response {
                    let sortedShoes = response.data.sorted { $0.maxPrice > $1.maxPrice }
                    let topShoes = Array(sortedShoes.prefix(3))
                    snapshot.deleteItems(snapshot.itemIdentifiers(inSection: .popular))

                    snapshot.deleteItems(snapshot.itemIdentifiers(inSection: .shoes))
                    snapshot.appendItems(topShoes.map { .popular(id: $0.id, title: $0.name, price: $0.minPrice) }, toSection: .popular)
                    snapshot.appendItems(response.data.map { .shoes(shoes: $0) }, toSection: .shoes)
                }
                wSelf.dataSource.apply(snapshot, animatingDifferences: false)
            }.store(in: &viewModel.cancellables)

        viewModel.$brands
            .receive(on: DispatchQueue.main)
            .sink { [weak self] brands in
                guard let wSelf = self else { return }
                var snapshot = wSelf.dataSource.snapshot()
                if let brands = brands {
                    snapshot.deleteItems(snapshot.itemIdentifiers(inSection: .brand))
                    snapshot.appendItems(brands.map { HomeCollectionContentCell.brand(id: $0.id, url: $0.thumbnail?.url, nameBrand: $0.name) }, toSection: .brand)
                    wSelf.dataSource.apply(snapshot, animatingDifferences: false)
                }
            }.store(in: &viewModel.cancellables)

        viewModel.$shoesFavoriteID
            .compactMap { $0 }
            .receive(on: DispatchQueue.main).sink { [weak self] _ in
                guard let wSelf = self else { return }
                let snapshot = wSelf.dataSource.snapshot()
                wSelf.dataSource.applySnapshotUsingReloadData(snapshot)
            }.store(in: &viewModel.cancellables)

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

    // MARK: - CollectionView Layout

    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }

            let sectionType = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]

            switch sectionType {
            case .banner:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.46381))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .paging
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
                return section

            case .popular:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85), heightDimension: .fractionalHeight(0.2))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0)

                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)

                // Add header
                section.boundarySupplementaryItems = self.createHeaderItem(for: sectionType)

                return section

            case .brand:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .absolute(100))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item, item, item])

                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .none

                section.interGroupSpacing = 10

                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 30, trailing: 16)

                return section

            case .shoes:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(268))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(268))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])

                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 20

                //   Add header
                if viewModel.shoesLoading {
                    section.boundarySupplementaryItems = self.createHeaderItem(for: sectionType, loadingView: true)
                } else {
                    section.boundarySupplementaryItems = self.createHeaderItem(for: sectionType)
                }

                return section
            }
        }
    }

    private func createHeaderItem(for _: HomeCollectionType, loadingView: Bool = false) -> [NSCollectionLayoutBoundarySupplementaryItem] {
        if !loadingView {
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(25))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top
            )
            header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0)
            return [header]
        } else {
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(25))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top
            )
            let footer = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom
            )
            return [header, footer]
        }
    }

    private func updateItem(_ item: HomeCollectionContentCell, in section: HomeCollectionType) {
        var snapshot = dataSource.snapshot()
        if snapshot.sectionIdentifiers.contains(section) {
            if let index = snapshot.itemIdentifiers(inSection: section).firstIndex(of: item) {
                snapshot.deleteItems([item])
                snapshot.insertItems([item], beforeItem: snapshot.itemIdentifiers(inSection: section)[index])
            } else {
                snapshot.appendItems([item], toSection: section)
            }
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }

    // MARK: - Action

    @objc func didTapSearchButton() {}

    @objc func didTapFavorite() {
        if TokenManager.shared.getAccessToken() == nil {
            showToast(message: "Please login to view favorite", chooseImageToast: .warning)
        } else {
            coordinator?.goToFavorite()
        }
    }
}

extension HomeViewController: ProductCollectionViewCellDelegate {
    func didTapFavButton(shoes: ShoeData) {
        if TokenManager.shared.getAccessToken() == nil {
            showToast(message: "Please login to add to favorite", chooseImageToast: .warning)
            return
        } else {
            viewModel.toggleFav(shoes: shoes)
        }
    }
}

extension HomeViewController: SkeletonCollectionViewDelegate, UICollectionViewDataSource {
    func numSections(in _: UICollectionView) -> Int {
        return 4
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = dataSource.itemIdentifier(for: indexPath)
        switch item {
        case .popular:
            let cell = collectionView.dequeueReusableCell(withType: PopularCollectionViewCell.self, for: indexPath)
            cell.setupCell(title: "", price: "")
            return cell
        case .brand:
            let cell = collectionView.dequeueReusableCell(withType: BrandCollectionViewCell.self, for: indexPath)
            cell.setupBrandCollectionView(url: nil, nameBrand: "")
            return cell
        case .shoes:
            let cell = collectionView.dequeueReusableCell(withType: ProductCollectionViewCell.self, for: indexPath)
            cell.setupCollectionView(shoes: nil)
            return cell
        case .banner:
            return collectionView.dequeueReusableCell(withType: BannerHomeCollectionViewCell.self, for: indexPath)
        default: return UICollectionViewCell()
        }
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataSource.itemIdentifier(for: indexPath)

        switch item {
        case let .popular(id, _, _):
            coordinator?.goToShoesDetail(idShoes: id)
        case let .brand(id, _, _):
            print("Clicked on Brand item with name: \(id)")
        case let .shoes(shoes):
            coordinator?.goToShoesDetail(idShoes: shoes.id)
        case .banner:
            print("Clicked on Banner item")
        default:
            break
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        let contentOffsetY = scrollView.contentOffset.y

        if contentOffsetY > contentHeight - scrollViewHeight + 30 {
            loadMoreDataIfNeeded()
        }
    }

    private func loadMoreDataIfNeeded() {
        if viewModel.hasNextPage && !viewModel.shoesLoading {
            viewModel.shoesLoading = true
            viewModel.getMoreShoes()
        }
    }
}

extension HomeViewController: HeaderHomeCollectionReusableViewDelegate {
    func didTapSeeMoreButton(homeCollectionType: HomeCollectionType) {
        print(homeCollectionType.title)
    }
}
