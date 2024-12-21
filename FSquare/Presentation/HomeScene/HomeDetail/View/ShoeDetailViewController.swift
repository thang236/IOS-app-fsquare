//
//  ShoeDetailViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 30/10/2024.
//

import AVKit
import Combine
import UIKit

enum ShoesDetailSectionType: String, CaseIterable, Hashable {
    case headerImage
    case describe
    case colorShoes
    case sizeShoes
    case description
    case review
    var title: String {
        switch self {
        case .headerImage:
            return "Header Image"
        case .describe:
            return "Miêu tả"
        case .sizeShoes:
            return "Kích thước"
        case .colorShoes:
            return "Màu sắc"
        case .description:
            return "Chi tiết sản phẩm"
        case .review:
            return "Đánh giá"
        }
    }
}

enum ShoeDetailContentCell: Hashable {
    case headerImage(image: String?)
    case describe(shoesDetailData: ShoesDetailData)
    case colorShoes(titleColor: String)
    case sizeShoes(titleSize: String)
    case description(description: String)
    case review(reviewData: ReviewData)
}

class ShoeDetailViewController: UIViewController {
    // MARK: - @IBOutlet

    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var BottomView: UIView!
    @IBOutlet private var quantityStackView: UIStackView!
    @IBOutlet private var quantityLabel: UILabel!
    @IBOutlet private var priceLbl: HeadingLabel!
    @IBOutlet private var stepperView: StepperView!

    // MARK: - Properties

    var coordinator: HomeCoordinator?
    private var popupVC = PopUpLoginViewController()
    private var selectedSizeIndexPath: IndexPath?
    private var selectedColorIndexPath: IndexPath?
    private var viewModel: ShoesDetailViewModel?
    private var shoesID: String?
    private var cancellables = Set<AnyCancellable>()
    private var popMedia: MediaViewController?
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
                    cell.action = {
                        if let isFav = self?.viewModel?.shoesDetail?.data?.isFavorite {
                            self?.viewModel?.toggleFav(isFav: isFav)
                        } else {
                            self?.showToast(message: "Đã có lỗi xảy ra vui lòng thử lại", chooseImageToast: .warning)
                        }
                    }
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
                case let .review(reviewData):
                    let cell = collectionView.dequeueReusableCell(withType: ReviewCollectionViewCell.self, for: indexPath)
                    cell.setupCell(reviewData: reviewData)
                    cell.delegate = self
                    return cell
                }
            }
            dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
                let section = ShoesDetailSectionType.allCases[indexPath.section]
                if kind == UICollectionView.elementKindSectionHeader {
                    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderHomeDetailCollectionReusableView.reuseIdentifier, for: indexPath) as? HeaderHomeDetailCollectionReusableView
                    header?.configure(shoesDetailSectionType: section)
                    return header
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
        popMedia = MediaViewController()
        popupVC.delegate = self
        stepperView.delegate = self
        stepperView.setMaxValue(maxValue: 1)
        setupCollectionView()
        setupBottomView()
        setupNav()
        viewModel?.initDataSource(idShoes: shoesID ?? "")
        setupBindings()
        view.isSkeletonable = true
        view.showAnimatedGradientSkeleton()
    }

    override func viewWillAppear(_: Bool) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_: Bool) {
        tabBarController?.tabBar.isHidden = false
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
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
        viewModel?.$reviewResponse
            .sink { reviewResponse in
                var snapshot = self.dataSource.snapshot()
                if let reviewResponse = reviewResponse {
                    snapshot.deleteItems(snapshot.itemIdentifiers(inSection: .review))
                    for reviewDataItem in reviewResponse.data {
                        if let reviewDataItem = reviewDataItem {
                            snapshot.appendItems([.review(reviewData: reviewDataItem)], toSection: .review)
                        }
                    }
                    self.dataSource.applySnapshotUsingReloadData(snapshot)
                }
            }.store(in: &cancellables)

        viewModel?.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { errorMessage in
                self.showToast(message: errorMessage, chooseImageToast: .warning)
                self.viewModel?.errorMessage = nil
            }.store(in: &cancellables)

        viewModel?.$shoesDetail.receive(on: DispatchQueue.main)
            .sink { shoesDetail in
                var snapshot = self.dataSource.snapshot()
                if let shoesDetailData = shoesDetail?.data {
                    self.view.hideSkeleton()
                    snapshot.deleteItems(snapshot.itemIdentifiers(inSection: .describe))
                    snapshot.deleteItems(snapshot.itemIdentifiers(inSection: .description))

                    snapshot.appendItems(
                        [.describe(shoesDetailData: shoesDetailData)], toSection: .describe
                    )
                    if let description = shoesDetailData.description {
                        snapshot.appendItems([.description(description: description)], toSection: .description)
                    }
                    self.priceLbl.text = NumberFormatter.formatToVNDWithCustomSymbol(shoesDetailData.minPrice)
                    self.dataSource.applySnapshotUsingReloadData(snapshot)
                } else {
                    let shoesDetailData = ShoesDetailData(id: "", name: "", brand: "", category: "", describe: "nil", description: "nil", classificationCount: 0, minPrice: 0, maxPrice: 0, rating: 0, reviewCount: 0, isFavorite: false, thumbnail: nil, sales: 0)
                    snapshot.appendItems([.describe(shoesDetailData: shoesDetailData)], toSection: .describe)

                    snapshot.appendItems([.description(description: shoesDetailData.describe)], toSection: .description)
                    self.dataSource.applySnapshotUsingReloadData(snapshot)
                }
            }.store(in: &cancellables)

        viewModel?.$shoesClassification
            .sink { shoesClassification in
                var snapshot = self.dataSource.snapshot()

                if let shoesClassificationData = shoesClassification?.data, shoesClassificationData.isEmpty == false {
                    let currentItems = snapshot.itemIdentifiers(inSection: .headerImage)
                    snapshot.deleteItems(currentItems)
                    for shoesClassificationItem in shoesClassificationData {
                        snapshot.appendItems([.headerImage(image: shoesClassificationItem.thumbnail?.url)], toSection: .headerImage)
                        snapshot.appendItems([.colorShoes(titleColor: shoesClassificationItem.color)], toSection: .colorShoes)
                    }
                    self.dataSource.applySnapshotUsingReloadData(snapshot)
                } else {
                    snapshot.appendItems([.headerImage(image: nil)], toSection: .headerImage)
                }
                self.dataSource.apply(snapshot, animatingDifferences: false)

            }.store(in: &cancellables)

        viewModel?.$sizesClassification.receive(on: DispatchQueue.main)
            .sink { sizesClassification in
                var snapshot = self.dataSource.snapshot()
                if let sizesClassification = sizesClassification {
                    snapshot.deleteItems(snapshot.itemIdentifiers(inSection: .sizeShoes))
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
                    guard let price = classifications.data?.price else { return }
                    self.priceLbl.text = NumberFormatter.formatToVNDWithCustomSymbol(price)
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
                    if addBagResponse.status == HTTPStatus.success.message || addBagResponse.status == HTTPStatus.created.message {
                        self.showToast(message: "Thêm vào giỏ hàng thành công", chooseImageToast: .success)
                    } else {
                        self.showToast(message: "Thêm vào giỏ hàng thất bại", chooseImageToast: .error)
                    }
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
        collectionView.registerCell(cellType: ReviewCollectionViewCell.self)

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
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(150))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(150))
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
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(150))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(150))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

                let section = NSCollectionLayoutSection(group: group)
                return section

            case .review:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

                let section = NSCollectionLayoutSection(group: group)

                section.boundarySupplementaryItems = self.createHeaderItem(for: sectionType)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)

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
        case .colorShoes:
            guard let shoesClassification = viewModel?.shoesClassification, !(shoesClassification.data.isEmpty) else {
                return []
            }
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(25))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top
            )
            header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            return [header]
        case .review:
            guard let reviewResponse = viewModel?.reviewResponse, !(reviewResponse.data.isEmpty) else {
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
        if TokenManager.shared.getAccessToken() != nil {
            if viewModel?.idSize == nil {
                showToast(message: "Vui lòng chọn màu và size", chooseImageToast: .warning)
                return
            } else {
                let quantity = stepperView.getValue()
                viewModel?.addToBag(quantity: quantity)
            }
        } else {
            popupVC.appear(sender: self)
        }
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

extension ShoeDetailViewController: PopUpLoginViewControllerDelegate {
    func didTapLoginButton() {
        coordinator?.goToLogin()
    }

    func didTapBackButton() {}
}

extension ShoeDetailViewController: ReviewCollectionViewCellDelegate {
    func didTapMediaItem(mediaItem: MediaItemGet) {
        switch mediaItem {
        case let .image(uRL):
            popMedia?.appear(sender: self, with: uRL)
        case let .video(uRL):
            let asset = AVAsset(url: uRL)
            let audioTracks = asset.tracks(withMediaType: .audio)

            if audioTracks.isEmpty {
                print("Video không chứa track audio.")
            } else {
                print("Video chứa \(audioTracks.count) track audio.")
            }

            let avPlayer = AVPlayer(url: uRL)
            let avController = AVPlayerViewController()
            avController.player = avPlayer
            avPlayer.isMuted = false
            avPlayer.volume = 1.0

            try? AVAudioSession.sharedInstance().setCategory(.playback, options: [.duckOthers, .allowBluetooth])
            try? AVAudioSession.sharedInstance().setActive(true)

            present(avController, animated: true) {
                avPlayer.play()
            }
        }
    }
}
