//
//  CheckOutViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 23/11/2024.
//

import UIKit

enum CheckOutCollectionType: String, CaseIterable, Hashable {
    case address
    case order
    case payment
    case total

    var title: String {
        switch self {
        case .address:
            return "Địa chỉ"
        case .payment:
            return "Phương thức thanh toán"
        case .order:
            return "Danh sách sản phẩm"
        case .total:
            return "Tổng"
        }
    }
}

enum CheckOutCollectionContentCell: Hashable {
    case address(address: AddressData)
    case order(bag: BagData)
    case payment
    case total(amount: Double?, shipping: Double?)
}

class CheckOutViewController: UIViewController {
    // MARK: - IBOutlet

    @IBOutlet private var collectionView: UICollectionView!

    @IBOutlet private var bottomView: UIView!
    let popUp = PopUpPaymentViewController()

    // MARK: - Properties

    private var viewModel: CartViewModel
    var coordinator: CartCoordinator?
    private var isPayment: Bool = false
    private var clientOrderCode: String
    private var totalAmount: Double?
    private var shippingFee: Double?
    private var weight: Double?

    private lazy var dataSource:
        UICollectionViewDiffableDataSource<CheckOutCollectionType, CheckOutCollectionContentCell> = {
            let dataSource = UICollectionViewDiffableDataSource<CheckOutCollectionType, CheckOutCollectionContentCell>(collectionView: self.collectionView) { [weak self] collectionView, indexPath, item in
                guard let wSelf = self else {
                    return UICollectionViewCell()
                }
                switch item {
                case let .address(address):
                    let cell = collectionView.dequeueReusableCell(withType: AddressCollectionViewCell.self, for: indexPath)
                    cell.setupCell(address: address)
                    cell.delegate = self
                    return cell

                case let .order(bag):
                    let cell = collectionView.dequeueReusableCell(withType: OrderCollectionViewCell.self, for: indexPath)
                    cell.setupCell(bag: bag)
                    return cell

                case .payment:
                    let cell = collectionView.dequeueReusableCell(withType: PaymentCollectionViewCell.self, for: indexPath)

                    cell.didTapPaymentView1 = {
                        self?.isPayment = false
                    }

                    cell.didTapPaymentView2 = {
                        self?.isPayment = true
                    }

                    return cell

                case let .total(amount, shipping):
                    let cell = collectionView.dequeueReusableCell(withType: TotalCollectionViewCell.self, for: indexPath)
                    cell.setupCell(amount: amount, shipping: shipping)
                    return cell
                }
            }
            dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
                let section = CheckOutCollectionType.allCases[indexPath.section]
                if kind == UICollectionView.elementKindSectionHeader {
                    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CheckOutHeaderCollectionReusableView.reuseIdentifier, for: indexPath) as? CheckOutHeaderCollectionReusableView
                    header?.configure(CheckOutCollectionType: section)

                    return header
                }

                return nil
            }

            return dataSource
        }()

    init(viewModel: CartViewModel) {
        self.viewModel = viewModel
        clientOrderCode = viewModel.generateRandomID()
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        viewModel.getAddress()
        popUp.delegate = self
        setupNav()
        setUpBinding()
    }

    override func viewWillAppear(_: Bool) {
        tabBarController?.tabBar.isHidden = true
        bottomView.layer.backgroundColor = UIColor.white.cgColor
        bottomView.layer.shadowColor = UIColor.borderDark.cgColor
        bottomView.layer.shadowOffset = CGSize(width: 0.0, height: -4.0)
        bottomView.layer.shadowRadius = 16
        bottomView.layer.shadowOpacity = 0.5
        bottomView.layer.masksToBounds = false

        bottomView.layer.cornerRadius = 16
    }

    private func setupNav() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(backButton))
        backButton.tintColor = .black
        setupNavigationBar(leftBarButton: backButton, title: "Thanh toán")
    }

    @objc private func backButton() {
        tabBarController?.tabBar.isHidden = false
        navigationController?.popViewController(animated: false)
    }

    private func calculatorFee(address: AddressData) {
        guard let bagData = viewModel.bagResponse?.data else { return }
        weight = bagData.reduce(0) { $0 + (($1.size?.weight ?? 1) * Double($1.quantity)) }
        guard let totalAmount = totalAmount, let weight = weight else { return }
        let parameters: [String: Any] = [
            "clientOrderCode": clientOrderCode,
            "toName": UserDefaults.standard.string(forKey: .nameUser) ?? "",
            "toPhone": UserDefaults.standard.string(forKey: .phoneUser) ?? "",
            "toAddress": address.address,
            "toWardName": address.wardName,
            "toDistrictName": address.districtName,
            "toProvinceName": address.provinceName,
            "weight": weight,
            "codAmount": totalAmount,
            "content": "\(bagData.count) loại sản phẩm",
        ]
        viewModel.calculatorFee(parameters: parameters)
        print("clientOrderCode", clientOrderCode)
    }

    private func createOrder() {
        guard let bagData = viewModel.bagResponse?.data else { return }

        let shippingAddress = ShippingAddress(
            toName: UserDefaults.standard.string(forKey: .nameUser) ?? "",
            toAddress: viewModel.addressChoose?.address ?? "",
            toProvinceName: viewModel.addressChoose?.provinceName ?? "",
            toDistrictName: viewModel.addressChoose?.districtName ?? "",
            toWardName: viewModel.addressChoose?.wardName ?? "",
            toPhone: UserDefaults.standard.string(forKey: .phoneUser) ?? ""
        )

        let order = Order(
            clientOrderCode: clientOrderCode,
            shippingAddress: shippingAddress,
            weight: weight ?? 0,
            codAmount: totalAmount ?? 0,
            shippingFee: shippingFee ?? 0,
            content: "\(bagData.count) đôi giày",
            isFreeShip: false,
            isPayment: isPayment,
            note: ""
        )

        let orderItems: [OrderItem] = bagData.map {
            OrderItem(
                size: $0.size?.id ?? "",
                shoes: $0.shoes?.id ?? "",
                quantity: $0.quantity,
                color: $0.color,
                thumbnail: nil,
                price: $0.price,
                id: nil
            )
        }

        let orderResponse = OrderRequest(
            order: order,
            orderItems: orderItems
        )

        viewModel.createOrder(parameters: orderResponse)
    }

    // MARK: - Methods

    private func setupCollectionView() {
        collectionView.registerCell(cellType: AddressCollectionViewCell.self)
        collectionView.registerCell(cellType: OrderCollectionViewCell.self)
        collectionView.registerCell(cellType: TotalCollectionViewCell.self)
        collectionView.registerCell(cellType: PaymentCollectionViewCell.self)

        collectionView.register(CheckOutHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CheckOutHeaderCollectionReusableView.reuseIdentifier)
        collectionView.collectionViewLayout = createLayout()

        var snapshot = NSDiffableDataSourceSnapshot<CheckOutCollectionType, CheckOutCollectionContentCell>()
        snapshot.appendSections(CheckOutCollectionType.allCases)
        if let bagData = viewModel.bagResponse?.data {
            snapshot.appendItems([.address(address: AddressData(id: "0", title: "", address: "", wardName: "", districtName: "", provinceName: "", isDefault: false))], toSection: .address)

            snapshot.appendItems(bagData.map { .order(bag: $0) }, toSection: .order)

            totalAmount = bagData.reduce(0) { $0 + ($1.price * Double($1.quantity)) }

            snapshot.appendItems([.total(amount: totalAmount, shipping: nil)], toSection: .total)

            snapshot.appendItems([.payment], toSection: .payment)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private func setUpBinding() {
        viewModel.$addressChoose
            .receive(on: RunLoop.main)
            .sink { [weak self] addressChoose in
                guard let self = self else { return }
                var snapshot = self.dataSource.snapshot()
                if let addressChoose = addressChoose {
                    snapshot.deleteItems(snapshot.itemIdentifiers(inSection: .address))
                    snapshot.appendItems([.address(address: addressChoose)], toSection: .address)
                    self.dataSource.applySnapshotUsingReloadData(snapshot)
                    calculatorFee(address: addressChoose)
                }
            }.store(in: &viewModel.cancellables)

        viewModel.$feeResponse
            .receive(on: RunLoop.main)
            .sink { feeResponse in
                var snapshot = self.dataSource.snapshot()
                snapshot.deleteItems(snapshot.itemIdentifiers(inSection: .total))
                self.shippingFee = feeResponse?.data
                snapshot.appendItems([.total(amount: self.totalAmount, shipping: feeResponse?.data)], toSection: .total)
                self.dataSource.applySnapshotUsingReloadData(snapshot)
            }.store(in: &viewModel.cancellables)

        viewModel.$orderResponse
            .receive(on: RunLoop.main)
            .sink { orderResponse in
               
                if let orderResponse = orderResponse {
                    if orderResponse.status == HTTPStatus.success.message || orderResponse.status == HTTPStatus.created.message {
                        self.popUp.appear(sender: self, isSuccess: true)
                        self.viewModel.removeAllBag()
                    } else {
                        self.popUp.appear(sender: self, isSuccess: false)
                    }
                    self.viewModel.orderResponse = nil
                }
            }.store(in: &viewModel.cancellables)

        viewModel.$postPaymentResponse
            .receive(on: RunLoop.main)
            .sink { paymentResponse in
                if let paymentResponse = paymentResponse {
                    if paymentResponse.status == HTTPStatus.success.message {
                        if let url = paymentResponse.data?.paymentUrl {
                            let baoKimVC = BaoKimViewController(url: url)
                            baoKimVC.onPaymentComplete = {
                                self.createOrder()
                                let popUp = PopUpPaymentViewController()
                                popUp.appear(sender: self, isSuccess: true)
                            }
                            self.navigationController?.pushViewController(baoKimVC, animated: false)
                        }
                    }
                    self.viewModel.postPaymentResponse = nil
                }
            }.store(in: &viewModel.cancellables)
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        .init { [weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            let sectionType = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]

            switch sectionType {
            case .address:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(84))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(84))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 20, trailing: 16)

                section.boundarySupplementaryItems = self.createHeaderItem(for: sectionType)
                return section

            case .order:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(150))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

                group.interItemSpacing = .fixed(10)
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
                section.boundarySupplementaryItems = self.createHeaderItem(for: sectionType)

                return section

            case .payment:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 20, trailing: 16)
                section.boundarySupplementaryItems = self.createHeaderItem(for: sectionType)

                return section

            case .total:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)

                return section
            }
        }
    }

    private func createHeaderItem(for _: CheckOutCollectionType) -> [NSCollectionLayoutBoundarySupplementaryItem] {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(25))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top
        )
        header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        return [header]
    }

    private func postPayment() {
        guard let totalAmount = totalAmount, let shippingFee = shippingFee else { return }
        let total = totalAmount + shippingFee
        let parameters: [String: Any] = [
            "clientOrderCode": clientOrderCode,
            "totalAmount": total,
            "toPhone": UserDefaults.standard.string(forKey: .phoneUser) ?? "",
        ]
        viewModel.postPayment(parameters: parameters)
    }

    @IBAction func didTapContinueButton(_: Any) {
        if shippingFee != nil {
            if isPayment {
                postPayment()
            } else {
                createOrder()
            }
        } else {
            showToast(message: "Thao tác quá nhanh vui lòng thử lại", chooseImageToast: .warning)
        }
    }
}

extension CheckOutViewController: PopUpPaymentViewControllerDelegate {
    func didTapViewOrder() {
        tabBarController?.tabBar.isHidden = false
        tabBarController?.selectedIndex = 2
        navigationController?.popViewController(animated: false)
    }

    func didTapHomeScreen() {
        tabBarController?.tabBar.isHidden = false
        tabBarController?.selectedIndex = 0
        navigationController?.popViewController(animated: false)
    }
}

extension CheckOutViewController: AddressCollectionViewCellDelegate {
    func didTapEditButton() {
        coordinator?.goToChooseAddress()
    }
}
