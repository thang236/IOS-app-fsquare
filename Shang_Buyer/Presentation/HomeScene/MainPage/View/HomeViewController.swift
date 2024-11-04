//
//  HomeViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 02/10/2024.
//

import Combine
import SkeletonView
import UIKit

class HomeViewController: UIViewController {
    // MARK: - Properties

    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.textAlignment = .center
        label.textColor = .gray
        label.isHidden = true
        return label
    }()

    // MARK: - Outlets

    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var heightShoesCollection: NSLayoutConstraint!
    @IBOutlet private var brandCollectionView: UICollectionView!
    @IBOutlet private var shoesCollectionView: UICollectionView! {
        didSet {
            shoesCollectionView.dataSource = self
            shoesCollectionView.delegate = self
            shoesCollectionView.registerCell(cellType: ProductCollectionViewCell.self, nibName: "ProductCollectionViewCell")
        }
    }

    @IBOutlet private var tt: HeadingLabel!
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var bannerHomeImage: UIImageView!

    // MARK: - Variables

    private var shoesPage = -1
    private var hasNextPage = true
    private var shoes = [ShoeData]()
    private var brands = [BrandItem]()
    private let viewModel: HomeViewModel
    private var isLoading = false
    var cancellables = Set<AnyCancellable>()
    var coordinator: HomeCoordinator?

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(shoesCollectionView.frame.height)
        if shoes.isEmpty {
            shoesCollectionView.isSkeletonable = true
            shoesCollectionView.showGradientSkeleton()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        shoesCollectionView.layoutIfNeeded()
        setupNavigationBar()
        setupBindings()
        setupCollectionView()
        bannerHomeImage.roundBottomCorners(radius: 30)
        //        self.viewModel.getShoes(page: self.shoesPage)
        viewModel.getBrand()
        view.layoutIfNeeded()

        contentView.addSubview(loadingLabel)
        setupLoadingLabelConstraints()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async {
            self.changeCollectionHeight()
        }
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

    // MARK: - SetupViews

    private func setupLoadingLabelConstraints() {
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            loadingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            loadingLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 20),
            loadingLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }

    private func setupNavigationBar() {
        let image = UIImage.logoBanner
        let logoButton = UIBarButtonItem(image: image.withRenderingMode(.alwaysOriginal), style: .done, target: nil, action: nil)
        navigationItem.leftBarButtonItem = logoButton

        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(didTapSearchButton))
        searchButton.tintColor = .white

        let favoriteButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(didTapFavorite))
        favoriteButton.tintColor = .white
        navigationItem.rightBarButtonItems = [favoriteButton, searchButton]

        navigationController?.navigationBar.barTintColor = .primaryDark
    }

    private func setupBindings() {
        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main).sink { [weak self] errorMessage in
                self?.showToast(message: errorMessage, chooseImageToast: .warning)
                self?.isLoading = false
                self?.loadingLabel.isHidden = true
            }.store(in: &cancellables)

        viewModel.$shoesResponse
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shoes in
                guard let shoes = shoes else { return }
                guard let wSelf = self else { return }
                wSelf.shoes.append(contentsOf: shoes.data)
                wSelf.hasNextPage = shoes.options.hasNextPage
                wSelf.shoesPage = shoes.options.page
                wSelf.isLoading = false
                wSelf.loadingLabel.isHidden = true
                wSelf.shoesCollectionView.reloadData()
                wSelf.shoesCollectionView.hideSkeleton(transition: .crossDissolve(0.25))
                wSelf.changeCollectionHeight()
            }
            .store(in: &cancellables)

        viewModel.$brands
            .receive(on: DispatchQueue.main).sink { [weak self] brands in
                self?.brands = brands
                self?.brandCollectionView.reloadData()
            }.store(in: &cancellables)
    }

    // MARK: - Setup Collection View

    private func setupCollectionView() {
        brandCollectionView.delegate = self
        brandCollectionView.dataSource = self
        brandCollectionView.registerCell(cellType: BrandCollectionViewCell.self, nibName: "BrandCollectionViewCell")

        scrollView.delegate = self
    }

    // MARK: - Actions

    @objc func didTapSearchButton() {}

    @objc func didTapFavorite() {}
}

extension HomeViewController: UIScrollViewDelegate {
    func loadMoreData() {
        guard !isLoading else { return }
        isLoading = true

        if hasNextPage {
            loadingLabel.isHidden = false
            DispatchQueue.main.async { [self] in
                if shoesPage == -1 {
                    shoesPage = 1
                } else {
                    shoesPage += 1
                }
                print("shoesPage \(shoesPage)")
                viewModel.getShoes(page: shoesPage)
            }

        } else {
            showToast(message: "No more shoes", chooseImageToast: .warning)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        if offsetY > contentHeight - height - 80 {
            loadMoreData()
        }
    }
}

extension HomeViewController: SkeletonCollectionViewDelegate, SkeletonCollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionSkeletonView(_: UICollectionView, cellIdentifierForItemAt _: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return "ProductCollectionViewCell"
    }

    func changeCollectionHeight() {
        heightShoesCollection.constant = shoesCollectionView.contentSize.height
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        if collectionView == shoesCollectionView {
            return shoes.count
        } else {
            return brands.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == shoesCollectionView {
            let cell = collectionView.dequeueReusableCell(withType: ProductCollectionViewCell.self, for: indexPath)
            cell.setupCollectionView(shoes: shoes.isEmpty ? nil : shoes[indexPath.row])
            cell.delegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withType: BrandCollectionViewCell.self, for: indexPath)
            cell.setupBrandCollectionView(brand: brands[indexPath.row])
            cell.showGradientSkeleton()
            return cell
        }
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        var width: CGFloat
        var height: CGFloat
        if collectionView == shoesCollectionView {
            width = (collectionView.frame.size.width - 30) / 2
            height = 268
        } else {
            width = (collectionView.frame.size.width - 50) / 4
            height = width
        }
        return CGSize(width: width, height: height)
    }
}

extension HomeViewController: ProductCollectionViewCellDelegate {
    func didTapFavButton(index _: Int) {}
}
