//
//  ProductViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 01/12/2024.
//

import UIKit

class ProductViewController: UIViewController {
    var titleScreen: String
    var coordinator: HomeCoordinator?
    var viewModel: HomeViewModel

    @IBOutlet var iconNil: UIImageView!
    @IBOutlet private var collectionView: UICollectionView!
    init(title: String, viewModel: HomeViewModel) {
        titleScreen = title
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        iconNil.isHidden = true
        setupCollectionView()
        setupBinding()
    }

    private func setupNav() {
        navigationItem.hidesBackButton = true
        let image: UIImage = #imageLiteral(resourceName: "positionLeft")
        guard let size = navigationController?.navigationBar.frame.height else {
            return
        }
        let resizedImage = image.resizeImage(targetSize: CGSize(width: size, height: size))
        let backButton = UIBarButtonItem(image: resizedImage, style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .neutralUltraDark
        setupNavigationBar(leftBarButton: backButton, title: titleScreen, rightBarButton: nil)
    }

    private func setupCollectionView() {
        collectionView.registerCell(cellType: ProductCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func setupBinding() {
        viewModel.$filterShoesResponse
            .receive(on: DispatchQueue.main)
            .sink { filterShoesResponse in

                if filterShoesResponse?.data.count != 0 {
                    self.iconNil.isHidden = true
                } else {
                    self.iconNil.isHidden = false
                }
                self.collectionView.reloadData()

            }.store(in: &viewModel.cancellables)
    }

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension ProductViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return viewModel.filterShoesResponse?.data.count ?? 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withType: ProductCollectionViewCell.self, for: indexPath)
        cell.setupCollectionView(shoes: viewModel.filterShoesResponse?.data[indexPath.row])
        cell.delegate = self
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.frame.size.width / 2) - 32
        let height: CGFloat = 268
        return CGSize(width: width, height: height)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16)
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.goToShoesDetail(idShoes: viewModel.filterShoesResponse?.data[indexPath.row].id ?? "")
    }
}

extension ProductViewController: ProductCollectionViewCellDelegate {
    func didTapFavButton(shoes: ShoeData) {
        if TokenManager.shared.getAccessToken() == nil {
            showToast(message: "Hãy đăng nhập để thêm vào yêu thích", chooseImageToast: .warning)
            return
        } else {
            viewModel.toggleFav(shoes: shoes)
        }
    }
}
