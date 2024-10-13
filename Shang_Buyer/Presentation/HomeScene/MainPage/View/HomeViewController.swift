//
//  HomeViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 02/10/2024.
//

import Combine
import UIKit

class HomeViewController: UIViewController {
    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.textAlignment = .center
        label.textColor = .gray
        label.isHidden = true // Ẩn label khi không cần thiết
        return label
    }()
    private var isLoading = false
    var cancellables = Set<AnyCancellable>()
    var coordinator: HomeCoordinator?
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private weak var heightShoesCollection: NSLayoutConstraint!
    @IBOutlet private var brandCollectionView: UICollectionView!
    @IBOutlet private var shoesCollectionView: UICollectionView!
    @IBOutlet private var tt: HeadingLabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet private var bannerHomeImage: UIImageView!
    private var shoesPage = 1

    private var shoes = [ShoeData]()
    private var brands = [BrandItem]()
    private let viewModel: HomeViewModel

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.setupNavigationBar()
            self.setupBindings()
            self.setupCollectionView()
            self.bannerHomeImage.roundBottomCorners(radius: 30)
            self.viewModel.getShoes(page: self.shoesPage)
            self.viewModel.getBrand()
            self.view.layoutIfNeeded()
        }
        contentView.addSubview(loadingLabel)

        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                loadingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                loadingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                loadingLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 20), // Cách dưới một khoảng
                loadingLabel.heightAnchor.constraint(equalToConstant: 20) // Chiều cao của label
            ])

    }

    private func setupBindings() {
        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main).sink { [weak self] errorMessage in
                self?.showToast(message: errorMessage, chooseImageToast: .warning)
            }.store(in: &cancellables)

        viewModel.$shoes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shoes in
                DispatchQueue.main.async {
                    self?.shoes.append(contentsOf: shoes)
                    self?.shoesCollectionView.reloadData()
                    self?.isLoading = false
                    self?.loadingLabel.isHidden = true // Ẩn label loading

                }
            }
            .store(in: &cancellables)


        viewModel.$brands
            .receive(on: DispatchQueue.main).sink { [weak self] brands in
                self?.brands = brands
                self?.brandCollectionView.reloadData()
            }.store(in: &cancellables)
    }

    private func setupCollectionView() {
        shoesCollectionView.delegate = self
        shoesCollectionView.dataSource = self
        shoesCollectionView.registerCell(cellType: ProductCollectionViewCell.self, nibName: "ProductCollectionViewCell")

        brandCollectionView.delegate = self
        brandCollectionView.dataSource = self
        brandCollectionView.registerCell(cellType: BrandCollectionViewCell.self, nibName: "BrandCollectionViewCell")
        
        scrollView.delegate = self
    }
    private func loadMoreShoesIfNeeded() {
        guard !isLoading else { return }
        isLoading = true
        loadingLabel.isHidden = false

        
        shoesPage += 1
        viewModel.getShoes(page: shoesPage)
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.changeCollectionHeight()
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

    @objc func didTapSearchButton() {}

    @objc func didTapFavorite() {}
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let scrollViewHeight = scrollView.frame.size.height

            print("offsetY: \(offsetY)")
        print("contentHeight - scrollViewHeight * 2: \(contentHeight - scrollViewHeight + 70)")
            if offsetY > contentHeight - scrollViewHeight + 100 {
                print(123)
                loadMoreShoesIfNeeded()
            }
        }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func changeCollectionHeight() {
        self.heightShoesCollection.constant = self.shoesCollectionView.contentSize.height
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        if collectionView == shoesCollectionView {
            if shoes.count == 0{
                return 10
            }else {
                return shoes.count
            }
            
        } else {
            return brands.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == shoesCollectionView {
            let cell = collectionView.dequeueReusableCell(withType: ProductCollectionViewCell.self, for: indexPath)
            cell.setupCollectionView(shoes: shoes[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withType: BrandCollectionViewCell.self, for: indexPath)
            cell.setupBrandCollectionView(brand: brands[indexPath.row])
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
