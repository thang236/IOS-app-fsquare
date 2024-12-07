//
//  OrderDetailViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 02/12/2024.
//

import UIKit

enum OrderDetailType: String, CaseIterable, Hashable {
    case infoAddress
    case order
    var title: String {
        switch self {
        case .infoAddress:
            return "Địa chỉ"
        case .order:
            return "ddonw hangf"
        }
    }
}

enum OrderDetailCollectionContentCell: Hashable {
    case infoAddress(orderData: OrderData)
    case order(orderItems: OrderItem)
}

class OrderDetailViewController: UIViewController {
    @IBOutlet var bottomHeight: NSLayoutConstraint!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var SingleButton: FullButton!
    @IBOutlet var StackTwoButton: UIStackView!
    @IBOutlet var secondButtonStack: FullButton!
    @IBOutlet var firstButtonStack: OutlineButton!
    @IBOutlet var collectionView: UICollectionView!
    private var viewModel: MyOrderViewModel

    init(viewModel: MyOrderViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var dataSource:
        UICollectionViewDiffableDataSource<OrderDetailType, OrderDetailCollectionContentCell> = {
            let dataSource = UICollectionViewDiffableDataSource<OrderDetailType, OrderDetailCollectionContentCell>(collectionView: self.collectionView) { [weak self] collectionView, indexPath, item in
                guard let wSelf = self else {
                    return UICollectionViewCell()
                }
                switch item {
                case let .infoAddress(orderData):
                    let cell = collectionView.dequeueReusableCell(withType: InfoOrderCollectionViewCell.self, for: indexPath)
                    cell.setupCell(orderData: orderData)
                    return cell

                case let .order(orderItems):
                    let cell = collectionView.dequeueReusableCell(withType: OrderListBagCollectionViewCell.self, for: indexPath)
                    cell.setupCell(orderItems: orderItems)
                    return cell
                }
            }

            return dataSource
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupBinding()
        setupNav()
    }

    func setupNav() {
        navigationItem.hidesBackButton = true
        let image: UIImage = #imageLiteral(resourceName: "positionLeft")
        guard let size = navigationController?.navigationBar.frame.height else {
            return
        }
        let resizedImage = image.resizeImage(targetSize: CGSize(width: size, height: size))
        let backButton = UIBarButtonItem(image: resizedImage, style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .neutralUltraDark
        setupNavigationBar(leftBarButton: backButton, title: "Chi tiết đơn hàng", rightBarButton: nil)
    }

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    override func viewWillAppear(_: Bool) {
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_: Bool) {
        tabBarController?.tabBar.isHidden = false
    }

    private func setBottomView(orderData: OrderData) {
        SingleButton.isHidden = true
        StackTwoButton.isHidden = true
        bottomHeight.constant = 0

        switch orderData.status {
        case "pending":
            bottomHeight.constant = 80
            SingleButton.isHidden = false
            SingleButton.setTitle("Huỷ đơn", for: .normal)
        case "processing":
            bottomHeight.constant = 0
        case "shipped":
            bottomHeight.constant = 0
        case "delivered":
            bottomHeight.constant = 80
            StackTwoButton.isHidden = false
        case "confirmed":
            if !(orderData.isReview ?? true) {
                bottomHeight.constant = 80
                SingleButton.isHidden = false
                SingleButton.setTitle("Đánh giá", for: .normal)
            }
        case "cancelled":
            bottomHeight.constant = 0
        case "returned":
            bottomHeight.constant = 0
        default:
            bottomHeight.constant = 0
        }
    }

    private func setupBinding() {
        viewModel.$orderDetailResponse
            .sink { [weak self] orderResponse in
                guard let wSelf = self else { return }
                var snapshot = wSelf.dataSource.snapshot()
                if let orderResponse = orderResponse {
                    if let orderData = orderResponse.data {
                        wSelf.setBottomView(orderData: orderData)

                        snapshot.deleteItems(snapshot.itemIdentifiers(inSection: .infoAddress))
                        snapshot.appendItems([.infoAddress(orderData: orderData)], toSection: .infoAddress)
                    }
                    if let orderItems = orderResponse.data?.orderItems {
                        snapshot.deleteItems(snapshot.itemIdentifiers(inSection: .order))
                        snapshot.appendItems(orderItems.map { .order(orderItems: $0) }, toSection: .order)
                    }
                    wSelf.dataSource.applySnapshotUsingReloadData(snapshot)
                }

            }.store(in: &viewModel.cancellables)
    }

    private func setupCollectionView() {
        collectionView.registerCell(cellType: InfoOrderCollectionViewCell.self)
        collectionView.registerCell(cellType: OrderListBagCollectionViewCell.self)
        collectionView.collectionViewLayout = createLayout()
        collectionView.dataSource = dataSource

        var snapshot = NSDiffableDataSourceSnapshot<OrderDetailType, OrderDetailCollectionContentCell>()
        snapshot.appendSections(OrderDetailType.allCases)

        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        .init { [weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            let sectionType = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]

            switch sectionType {
            case .infoAddress:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(270))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(270))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
                return section

            case .order:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 0, trailing: 16)
                return section
            }
        }
    }

    @IBAction func didTapSingleButton(_: Any) {
        switch viewModel.orderDetailResponse?.data?.status {
        case "pending":
            viewModel.patchOrderStatus(idOrder: viewModel.orderDetailResponse?.data?.id ?? "", newStatus: "cancelled") { completion in
                switch completion {
                case let .success(success):
                    if success.status == HTTPStatus.success.message {
                        self.viewModel.getOrderDetail(idOrder: self.viewModel.orderDetailResponse?.data?.id ?? "")
                        self.showToast(message: success.message, chooseImageToast: .success)
                    }
                case let .failure(failure):
                    self.showToast(message: failure.localizedDescription, chooseImageToast: .error)
                }
            }
        case "confirmed":
            if let orderData = viewModel.orderDetailResponse?.data {
                showMyViewControllerInACustomizedSheet(orderData: orderData)
            } else {
                showToast(message: "Đã có lỗi xảy ra", chooseImageToast: .warning)
            }
        default:
            print("default")
        }
    }

    @IBAction func didTapLeftButton(_ sender: Any) {
        let popUp = ReturnOrderViewController()
        popUp.delegate = self
        popUp.appear(sender: self)
    }

    @IBAction func didTapRightButton(_: Any) {
        viewModel.patchOrderStatus(idOrder: viewModel.orderDetailResponse?.data?.id ?? "", newStatus: "delivered") { completion in
            switch completion {
            case let .success(success):
                if success.status == HTTPStatus.success.message {
                    self.viewModel.getOrderDetail(idOrder: self.viewModel.orderDetailResponse?.data?.id ?? "")
                    self.showToast(message: "Đơn hàng đã được xác nhận", chooseImageToast: .success)
                }
            case let .failure(failure):
                self.showToast(message: failure.localizedDescription, chooseImageToast: .error)
            }
        }
    }

    func showMyViewControllerInACustomizedSheet(orderData: OrderData) {
        let orderStatusData = OderStatusData(from: orderData)
        let viewControllerToPresent = RattingViewController(oderStatusData: orderStatusData)
        viewControllerToPresent.delegate = self
        if let sheet = viewControllerToPresent.sheetPresentationController {
            let seventyPercentDetent = UISheetPresentationController.Detent.custom { context in
                context.maximumDetentValue * 0.8
            }

            sheet.detents = [seventyPercentDetent]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            sheet.prefersGrabberVisible = true
        }
        present(viewControllerToPresent, animated: true, completion: nil)
    }
}

extension OrderDetailViewController: RattingViewControllerDelegate {
    func didTapSubmit() {
        viewModel.getOrderDetail(idOrder: viewModel.orderDetailResponse?.data?.id ?? "")
    }
}

extension OrderDetailViewController: ReturnOrderViewControllerDelegate {
    func didTapSubmitReturn(content: String) {
        viewModel.returnOrder(idOrder: viewModel.orderDetailResponse?.data?.id ?? "", reason: content) { completion in
            switch completion {
            case let .success(success):
                if success.status == HTTPStatus.success.message {
                    self.viewModel.getOrderDetail(idOrder: self.viewModel.orderDetailResponse?.data?.id ?? "")
                    self.showToast(message: "Đơn hàng sẽ vào trạng thái trả hàng", chooseImageToast: .success)
                }
            case let .failure(failure):
                self.showToast(message: failure.localizedDescription, chooseImageToast: .error)
            }
        }
    }
}
