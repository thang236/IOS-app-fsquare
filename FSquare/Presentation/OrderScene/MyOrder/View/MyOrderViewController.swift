//
//  MyOrderViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 02/10/2024.
//

import UIKit

class MyOrderViewController: UIViewController {
    private let refreshControl = UIRefreshControl()
    var coordinator: OrderCoordinator?
    var viewModel: MyOrderViewModel
    private var statusArray: [String] = [OrderStatus.pending.title, OrderStatus.processing.title, OrderStatus.shipped.title, OrderStatus.delivered.title, OrderStatus.confirmed.title, OrderStatus.cancelled.title, OrderStatus.returned.title]
    private var selectedIndexPath: IndexPath = [0, 0]
    private var popUpCancel : PopUpCanncelViewController?
    private var popUpConfirm : PopConfirmViewController?

    @IBOutlet private var iconNil: UIImageView!
    @IBOutlet private var topCollectionView: UICollectionView!
    @IBOutlet private var orderCollectionView: UICollectionView!
    
    init(viewModel: MyOrderViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        checkGust()
        setupCollectionView()
        setupBinding()
        setupNavigationBar(title: "Đơn hàng")
        popUpCancel = PopUpCanncelViewController(viewModel: viewModel)
        popUpConfirm = PopConfirmViewController(viewModel: viewModel)
        
        DispatchQueue.main.async {
            self.topCollectionView.selectItem(at: self.selectedIndexPath, animated: false, scrollPosition: .centeredHorizontally)

            if let cell = self.topCollectionView.cellForItem(at: self.selectedIndexPath) as? StatusOrderCollectionViewCell {
                cell.chooseCell()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        checkGust()
    }
    private func checkGust() {
        if TokenManager.shared.getAccessToken() == nil {
            let popUp = PopUpLoginViewController()
            popUp.delegate = self
            popUp.appear(sender: self)
        } else {
            viewModel.getOrder(orderStatus: OrderStatus.allStatuses[selectedIndexPath.row])
        }
    }

    private func setupCollectionView() {
        topCollectionView.delegate = self
        topCollectionView.dataSource = self
        topCollectionView.registerCell(cellType: StatusOrderCollectionViewCell.self)

        orderCollectionView.delegate = self
        orderCollectionView.dataSource = self
        orderCollectionView.registerCell(cellType: OrderListCollectionViewCell.self)
        refreshControl.addTarget(self, action: #selector(refreshFavorites), for: .valueChanged)
        orderCollectionView.refreshControl = refreshControl
    }

    @objc private func refreshFavorites() {
        viewModel.getOrder(orderStatus: OrderStatus.allStatuses[selectedIndexPath.row]) { [self] in
            refreshControl.endRefreshing()
        }
    }

    private func setupBinding() {
        viewModel.$orderStatusResponse
            .sink(receiveValue: { [weak self] orderStatusResponse in
                self?.orderCollectionView.reloadData()
                if let count = orderStatusResponse?.data?.count {
                    if count == 0 {
                        self?.iconNil.isHidden = false
                    } else {
                        self?.iconNil.isHidden = true
                    }
                }
            })
            .store(in: &viewModel.cancellables)
    }

    func showMyViewControllerInACustomizedSheet(orderStatusData: OderStatusData) {
        let viewControllerToPresent = RattingViewController(oderStatusData: orderStatusData)
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

extension MyOrderViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        if collectionView == topCollectionView {
            return statusArray.count
        } else {
            guard let index = viewModel.orderStatusResponse?.data?.count else { return 5 }
            return index
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == topCollectionView {
            let cell = collectionView.dequeueReusableCell(withType: StatusOrderCollectionViewCell.self, for: indexPath)
            cell.setupCell(title: statusArray[indexPath.row])
            if indexPath == selectedIndexPath {
                cell.chooseCell()
            } else {
                cell.unChooseCell()
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withType: OrderListCollectionViewCell.self, for: indexPath)
            cell.setupCell(oderStatusData: viewModel.orderStatusResponse?.data?[indexPath.row])
            cell.didTapAction = { [self] statusOrder in
                let idOrder = statusOrder.id
                let statusOrderString = statusOrder.status
                if statusOrderString == "confirmed" {
                    self.showMyViewControllerInACustomizedSheet(orderStatusData: statusOrder)
                } else {
                    if statusOrderString == "pending" {
                        popUpCancel?.appear(sender: self, idOrder: idOrder)
                    } else if statusOrderString == "delivered" {
                        popUpConfirm?.appear(sender: self, idOrder: idOrder)
//                        self.viewModel.patchOrderStatus(idOrder: idOrder, newStatus: newStatus)
                    }
                }
            }
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        if collectionView == topCollectionView {
            let width: CGFloat = collectionView.frame.size.width / 2.7
            let height: CGFloat = 60
            return CGSize(width: width, height: height)
        } else {
            let width: CGFloat = collectionView.frame.size.width - 32
            let height: CGFloat = 134
            return CGSize(width: width, height: height)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        if collectionView == topCollectionView {
            return 0
        } else {
            return 10
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        if collectionView == topCollectionView {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            return UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == topCollectionView {
            let previousIndexPath = selectedIndexPath

            if previousIndexPath != indexPath {
                if let previousCell = collectionView.cellForItem(at: previousIndexPath) as? StatusOrderCollectionViewCell {
                    previousCell.unChooseCell()
                }
            }

            if let currentCell = collectionView.cellForItem(at: indexPath) as? StatusOrderCollectionViewCell {
                currentCell.chooseCell()
                if indexPath.row < OrderStatus.allStatuses.count {
                    let status = OrderStatus.allStatuses[indexPath.row]
                    viewModel.getOrder(orderStatus: status)
                }
            }
            selectedIndexPath = indexPath
        } else {
            let idOrder = viewModel.orderStatusResponse?.data?[indexPath.row]?.id ?? ""
            viewModel.getOrderDetail(idOrder: idOrder)
            coordinator?.showOrderDetail()
        }
    }
}

extension MyOrderViewController: PopUpLoginViewControllerDelegate {
    func didTapLoginButton() {
        coordinator?.goToLogin()
    }
    
    func didTapBackButton() {
        tabBarController?.selectedIndex = 0
    }
}
