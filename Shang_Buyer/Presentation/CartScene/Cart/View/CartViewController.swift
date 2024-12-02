//
//  CartViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 02/10/2024.
//

import UIKit

class CartViewController: UIViewController {
    private let refreshControl = UIRefreshControl()
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var iconNil: UIImageView!
    @IBOutlet var checkOutButton: FullButton!
    var coordinator: CartCoordinator?
    var viewModel: CartViewModel
    init(viewModel: CartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupBinding()
        setupNav()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getBag()
    }

    private func setupNav() {
        let removeAllButton = UIBarButtonItem(image: UIImage.listRemove, style: .plain, target: self, action: #selector(removeAll))
        removeAllButton.tintColor = .black
        removeAllButton.image = removeAllButton.image?.withRenderingMode(.alwaysOriginal)
        removeAllButton.image = removeAllButton.image?.resizeImage(targetSize: CGSize(width: 24, height: 24))
        setupNavigationBar(title: "Giỏ hàng", rightBarButton: [removeAllButton])
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCell(cellType: CartCollectionViewCell.self)
        refreshControl.addTarget(self, action: #selector(refreshCart), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }

    @objc private func refreshCart() {
        viewModel.getBag { [self] in
            self.refreshControl.endRefreshing()
        }
    }

    private func updatePrice() {
        if let totalPrice = viewModel.bagResponse?.data?.map({ $0.price * Double($0.quantity) }).reduce(0, +) {
            let priceFormat = NumberFormatter.formatToVNDWithCustomSymbol(totalPrice)
            checkOutButton.setTitle("\(priceFormat) Thanh toán", for: .normal)
        }
    }

    private func setupBinding() {
        viewModel.$bagResponse
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
                self?.updatePrice()
                if let bagCount = self?.viewModel.bagResponse?.data?.count, bagCount == 0 {
                    self?.iconNil.isHidden = false
                } else {
                    self?.iconNil.isHidden = true
                }
            }
            .store(in: &viewModel.cancellables)

        viewModel.$bagPatchResponse
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
                self?.updatePrice()
            }
            .store(in: &viewModel.cancellables)

        viewModel.$bagDeleteResponse
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
                self?.updatePrice()
            }
            .store(in: &viewModel.cancellables)

        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .sink { [weak self] errorMessage in
                print("errorMessage:  \(errorMessage)")
                self?.showToast(message: errorMessage, chooseImageToast: .warning)
            }.store(in: &viewModel.cancellables)
    }

    @objc func removeAll() {
        showAlertWithActions(title: "Cảnh báo", message: "Bản có muốn xoá hết sản phẩm trong giỏ hàng không ?", okAction: { [self] in
            viewModel.removeAllBag()
            updatePrice()
        })
    }

    @IBAction func didTapCheckOutButton(_: Any) {
        if viewModel.bagResponse?.data?.count == 0 {
            showToast(message: "Giỏ hàng của bạn đang trống", chooseImageToast: .warning)
        } else {
            coordinator?.goToCheckOut()
        }
    }
}

extension CartViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        guard let data = viewModel.bagResponse?.data?.count else { return 10 }
        return data
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withType: CartCollectionViewCell.self, for: indexPath)
        cell.setupCell(bag: viewModel.bagResponse?.data?[indexPath.row])
        cell.delegate = self
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.frame.size.width - 32)
        let height: CGFloat = 134
        return CGSize(width: width, height: height)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16)
    }
}

extension CartViewController: CartCollectionViewCellDelegate {
    func increaseQuantity(bag: BagData) {
        viewModel.patchBag(idBag: bag.id, quantity: bag.quantity + 1)
    }

    func decreaseQuantity(bag: BagData) {
        if bag.quantity == 1 {
            showAlertWithActions(title: "Cảnh báo", message: "số lượng không thể thấp hơn 1 bạn có muốn xoá sản phẩm này không ?", okAction: { [self] in
                self.viewModel.removeBag(idBag: bag.id)
            })
        } else {
            viewModel.patchBag(idBag: bag.id, quantity: bag.quantity - 1, isDecrease: true)
        }
    }

    func deleteItem(bag: BagData) {
        showAlertWithActions(title: "Cảnh báo", message: "Bạn có muốn xoá sản phẩm này không ?", okAction: { [self] in
            self.viewModel.removeBag(idBag: bag.id)
        })
    }
}
