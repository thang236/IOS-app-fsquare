//
//  ShoeDetailViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 30/10/2024.
//

import Combine
import UIKit

enum ShoesDetailSectionType: Int, CaseIterable, Hashable {
    case headerImage
    case describe
    case description
}

enum ShoeDetailContentCell: Hashable {
    case headerImage(image: String)
    case describe(shoesDetailData: ShoesDetailData)
    case description(description: String)
}

class ShoeDetailViewController: UIViewController {
    // MARK: - @IBOutlet

    @IBOutlet private var collectionView: UICollectionView!

    @IBOutlet var BottomView: UIView!

    @IBOutlet var priceLbl: HeadingLabel!

    // MARK: - Properties

    private var viewModel: ShoesDetailViewModel?
    private var shoesID: String?
    private var cancellables = Set<AnyCancellable>()
    private lazy var dataSource:
        UICollectionViewDiffableDataSource<ShoesDetailSectionType, ShoeDetailContentCell> = {
            let dataSource = UICollectionViewDiffableDataSource<ShoesDetailSectionType, ShoeDetailContentCell>(collectionView: self.collectionView) { [weak self] collectionView, indexPath, item in
                guard let wSelf = self else {
                    return UICollectionViewCell()
                }
                switch item {
                case let .headerImage(image):
                    let cell = collectionView.dequeueReusableCell(withType: HeaderShoesDetailCollectionViewCell.self, for: indexPath)
                    cell.configureCell(image: image)
                    return cell
                case let .describe(shoesDetailData):
                    let cell = collectionView.dequeueReusableCell(withType: DescribeCollectionViewCell.self, for: indexPath)
                    cell.configureCell(shoesDetailData: shoesDetailData)
                    return cell
                case let .description(description):
                    let cell = collectionView.dequeueReusableCell(withType: DescriptionCollectionViewCell.self, for: indexPath)
                    cell.configureCell(description: description)
                    return cell
                }
            }
            return dataSource
        }()

    // MARK: - Initializer

    init(shoesID: String, viewModel: ShoesDetailViewModel) {
        self.viewModel = viewModel
        self.shoesID = shoesID
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupBottomView()
        setupNav()
        viewModel?.initDataSource(idShoes: shoesID ?? "")
        setupBindings()
    }

    override func viewWillAppear(_: Bool) {
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_: Bool) {
        tabBarController?.tabBar.isHidden = false
    }

    func setupNav() {
        navigationItem.hidesBackButton = true

        let image: UIImage = #imageLiteral(resourceName: "positionLeft")
        guard let size = navigationController?.navigationBar.frame.height else {
            return
        }
        let resizedImage = image.resizeImage(targetSize: CGSize(width: size, height: size))
        let backButton = UIBarButtonItem(image: resizedImage, style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = UIColor.neutralUltraDark
        setupNavigationBar(leftBarButton: backButton, title: "", rightBarButton: nil)
    }

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    private func setupBottomView() {
        BottomView.addTopBorder(color: .borderMedium, thickness: 1)
    }

    // MARK: - Setup Bindings

    private func setupBindings() {
        viewModel?.$shoesDetail.receive(on: DispatchQueue.main)
            .sink { shoesDetail in
                if let shoesDetail = shoesDetail {
                    var snapshot = NSDiffableDataSourceSnapshot<ShoesDetailSectionType, ShoeDetailContentCell>()
                    snapshot.appendSections(ShoesDetailSectionType.allCases)
                    snapshot.appendItems([.headerImage(image: shoesDetail.data.thumbnail.url)], toSection: .headerImage)
                    snapshot.appendItems(
                        [.describe(shoesDetailData: shoesDetail.data)], toSection: .describe
                    )
                    snapshot.appendItems([.description(description: shoesDetail.data.description)], toSection: .description)
                    self.priceLbl.text = "$\(shoesDetail.data.minPrice)"
                    self.dataSource.apply(snapshot, animatingDifferences: true)
                }
            }.store(in: &cancellables)

        viewModel?.$shoesClassification
            .sink { _ in
//                if let shoesClassification = shoesClassification {
//                    var snapshot = NSDiffableDataSourceSnapshot<ShoesDetailSectionType, ShoeDetailContentCell>()
//                    snapshot.appendSections(ShoesDetailSectionType.allCases)
//
//                    self.dataSource.apply(snapshot, animatingDifferences: true)
//
//                }
            }.store(in: &cancellables)
    }

    // MARK: - Collection View Setup

    private func setupCollectionView() {
        collectionView.registerCell(cellType: DescribeCollectionViewCell.self)
        collectionView.registerCell(cellType: HeaderShoesDetailCollectionViewCell.self)
        collectionView.registerCell(cellType: DescriptionCollectionViewCell.self)

        collectionView.collectionViewLayout = createLayout()

        var snapshot = NSDiffableDataSourceSnapshot<ShoesDetailSectionType, ShoeDetailContentCell>()
        snapshot.appendSections(ShoesDetailSectionType.allCases)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    // MARK: - Collection View Layout

    private func createLayout() -> UICollectionViewCompositionalLayout {
        .init { [weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            let sectionType = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]

            switch sectionType {
            case .headerImage:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(self.view.frame.width))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(self.view.frame.width))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                return section

            case .describe:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0)

                return section

            case .description:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                return section
            }
        }
    }

    // MARK: - @IBAction

    @IBAction func didTapAddToCart(_: Any) {}
}
