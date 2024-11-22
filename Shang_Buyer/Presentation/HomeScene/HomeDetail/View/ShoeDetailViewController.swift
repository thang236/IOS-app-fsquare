//
//  ShoeDetailViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 30/10/2024.
//

import Combine
import UIKit

enum ShoesDetailSectionType: String, CaseIterable, Hashable {
    case headerImage
    case describe
    case colorShoes
    case sizeShoes
    case description
    var title: String {
        switch self {
        case .headerImage:
            return "Header Image"
        case .describe:
            return "Describe"
        case .sizeShoes:
            return "Size"
        case .colorShoes:
            return "Color"
        case .description:
            return "Description"
        }
    }
}

enum ShoeDetailContentCell: Hashable {
    case headerImage(image: String)
    case describe(shoesDetailData: ShoesDetailData)
    case colorShoes(titleColor: String)
    case sizeShoes(titleSize: String)
    case description(description: String)
}

class ShoeDetailViewController: UIViewController {
    // MARK: - @IBOutlet

    @IBOutlet private var collectionView: UICollectionView!

    @IBOutlet var BottomView: UIView!

    @IBOutlet private var quantityStackView: UIStackView!
    @IBOutlet private var quantityLabel: UILabel!
    @IBOutlet private var priceLbl: HeadingLabel!

    @IBOutlet var stepperView: StepperView!

    // MARK: - Properties

    private var selectedSizeIndexPath: IndexPath?
    private var selectedColorIndexPath: IndexPath?
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
                case let .sizeShoes(titleSize):
                    let cell = collectionView.dequeueReusableCell(withType: SizeCollectionViewCell.self, for: indexPath)
                    cell.setupCell(titleButton: titleSize)
                    return cell
                case let .colorShoes(titleColor):
                    let cell = collectionView.dequeueReusableCell(withType: ShoesColorCollectionViewCell.self, for: indexPath)
                    cell.setupCell(titleButton: titleColor)
                    return cell
                case let .description(description):
                    let cell = collectionView.dequeueReusableCell(withType: DescriptionCollectionViewCell.self, for: indexPath)
                    cell.configureCell(description: description)
                    return cell
                }
            }
            dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
                let section = ShoesDetailSectionType.allCases[indexPath.section]
                if kind == UICollectionView.elementKindSectionHeader {
                    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderHomeDetailCollectionReusableView.reuseIdentifier, for: indexPath) as? HeaderHomeDetailCollectionReusableView
                    header?.configure(shoesDetailSectionType: section)
                    switch section {
                    case .headerImage:
                        return nil
                    case .describe:
                        return nil
                    case .sizeShoes:
                        return header
                    case .colorShoes:
                        return header
                    case .description:
                        return nil
                    }
                }

                return nil
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
        stepperView.delegate = self
        stepperView.setMaxValue(maxValue: 1)
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
                    var snapshot = self.dataSource.snapshot()
                    snapshot.appendItems(
                        [.describe(shoesDetailData: shoesDetail.data)], toSection: .describe
                    )
                    snapshot.appendItems([.description(description: shoesDetail.data.description)], toSection: .description)
                    self.priceLbl.text = "$\(shoesDetail.data.minPrice)"
                    self.dataSource.apply(snapshot, animatingDifferences: false)
                }
            }.store(in: &cancellables)

        viewModel?.$shoesClassification
            .sink { shoesClassification in
                if let shoesClassification = shoesClassification {
                    var snapshot = self.dataSource.snapshot()
                    for shoesClassificationItem in shoesClassification.data {
                        snapshot.appendItems([.headerImage(image: shoesClassificationItem.thumbnail.url)], toSection: .headerImage)
                        snapshot.appendItems([.colorShoes(titleColor: shoesClassificationItem.color)], toSection: .colorShoes)
                    }

                    self.dataSource.apply(snapshot, animatingDifferences: false)
                }
            }.store(in: &cancellables)

        viewModel?.$sizesClassification.receive(on: DispatchQueue.main)
            .sink { sizesClassification in
                var snapshot = self.dataSource.snapshot()
                if let sizesClassification = sizesClassification {
                    guard let sizesClassificationData = sizesClassification.data else { return }
                    for sizesClassificationDataItem in sizesClassificationData {
                        snapshot.appendItems([.sizeShoes(titleSize: sizesClassificationDataItem.sizeNumber)], toSection: .sizeShoes)
                        self.quantityStackView.isHidden = false
                        self.quantityLabel.text = "\(sizesClassificationData[0].quantity)"
                        self.stepperView.setMaxValue(maxValue: sizesClassificationData[0].quantity)
                    }
                    self.dataSource.apply(snapshot, animatingDifferences: false)
                } else {
                    self.quantityStackView.isHidden = true
                }
            }.store(in: &cancellables)

        viewModel?.$classifications
            .sink { classifications in
                if let classifications = classifications {
                    self.priceLbl.text = "₫ \(classifications.data.price)"
                }
            }.store(in: &cancellables)
        viewModel?.$quantity
            .sink { quantity in
                if let quantity = quantity {
                    self.quantityLabel.text = "\(quantity)"
                    self.stepperView.setMaxValue(maxValue: quantity)
                    self.quantityStackView.isHidden = false
                    return
                } else {
                    self.quantityStackView.isHidden = true
                }
            }.store(in: &cancellables)

        viewModel?.$addBagResponse
            .sink { addBagResponse in
                if let addBagResponse = addBagResponse {
                    self.showToast(message: addBagResponse.message, chooseImageToast: .success)
                }
            }.store(in: &cancellables)
    }

    // MARK: - Collection View Setup

    private func setupCollectionView() {
        collectionView.registerCell(cellType: DescribeCollectionViewCell.self)
        collectionView.registerCell(cellType: HeaderShoesDetailCollectionViewCell.self)
        collectionView.registerCell(cellType: DescriptionCollectionViewCell.self)
        collectionView.registerCell(cellType: SizeCollectionViewCell.self)
        collectionView.registerCell(cellType: ShoesColorCollectionViewCell.self)

        collectionView.delegate = self

        // Register Header
        collectionView.register(HeaderHomeDetailCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderHomeDetailCollectionReusableView.reuseIdentifier)

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
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(self.view.frame.width))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous

                return section

            case .describe:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0)

                return section

            case .sizeShoes:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(34),
                    heightDimension: .fractionalHeight(1)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(34))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(5)

                let section = NSCollectionLayoutSection(group: group)

                section.boundarySupplementaryItems = self.createHeaderItem(for: sectionType)
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)

                return section

            case .colorShoes:
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(92), heightDimension: .absolute(35))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(35))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(5)

                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

                section.boundarySupplementaryItems = self.createHeaderItem(for: sectionType)
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
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

    private func createHeaderItem(for sectionType: ShoesDetailSectionType) -> [NSCollectionLayoutBoundarySupplementaryItem] {
        switch sectionType {
        case .sizeShoes:
            guard let sizesClassification = viewModel?.sizesClassification, !(sizesClassification.data?.isEmpty ?? false) else {
                return []
            }
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(25))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top
            )
            header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            return [header]

        default:
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(25))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top
            )
            header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            return [header]
        }
    }

    // MARK: - @IBAction

    @IBAction func didTapAddToCart(_: Any) {
        let quantity = stepperView.getValue()
        viewModel?.addToBag(quantity: quantity)
    }
}

extension ShoeDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataSource.itemIdentifier(for: indexPath)
        switch item {
        case .sizeShoes:

            if let previousIndexPath = selectedSizeIndexPath, previousIndexPath != indexPath {
                if let previousCell = collectionView.cellForItem(at: previousIndexPath) as? SizeCollectionViewCell {
                    previousCell.setCellUnChoose()
                }
            }

            if let currentCell = collectionView.cellForItem(at: indexPath) as? SizeCollectionViewCell {
                currentCell.setCellChoose()
            }
            selectedSizeIndexPath = indexPath

            viewModel?.idSize = viewModel?.sizesClassification?.data?[indexPath.row].id
            viewModel?.quantity = viewModel?.sizesClassification?.data?[indexPath.row].quantity ?? 0

        case .colorShoes:
            if let previousIndexPath = selectedColorIndexPath, previousIndexPath != indexPath {
                if let previousCell = collectionView.cellForItem(at: previousIndexPath) as? ShoesColorCollectionViewCell {
                    previousCell.setUnChooseCell()
                }
            }

            if let currentCell = collectionView.cellForItem(at: indexPath) as? ShoesColorCollectionViewCell {
                currentCell.setChooseCell()
            }
            selectedColorIndexPath = indexPath
            viewModel?.getClassificationAndSize(idClassification: viewModel?.shoesClassification?.data[indexPath.row].id ?? "")

            if let previousIndexPath = selectedSizeIndexPath {
                if let previousCell = collectionView.cellForItem(at: previousIndexPath) as? SizeCollectionViewCell {
                    previousCell.setCellUnChoose()
                }
            }

        default:
            print(123)
        }
    }
}

extension ShoeDetailViewController: StepperViewDelegate {
    func showToast(message: String) {
        showToast(message: message, chooseImageToast: .warning)
    }
}
