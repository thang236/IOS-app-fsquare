//
//  SearchHomeViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 04/12/2024.
//

import UIKit

class SearchHomeViewController: UIViewController {
    @IBOutlet var iconNil: UIImageView!
    @IBOutlet var historyCollectionView: UICollectionView!
    @IBOutlet var shoesCollectionView: UICollectionView!
    private var viewModel: HomeViewModel
    var coordinator: HomeCoordinator?
    private let searchBar = UISearchBar()

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        viewModel.getHistory()
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
        setupDismissKeyboardGesture()
    }

    private func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // Đảm bảo các sự kiện khác vẫn được xử lý
        historyCollectionView.addGestureRecognizer(tapGesture)
        shoesCollectionView.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        searchBar.endEditing(true) // Ẩn bàn phím
    }

    private func setupNav() {
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItems = nil
        navigationItem.leftBarButtonItems = nil

        let image: UIImage = #imageLiteral(resourceName: "positionLeft")
        guard let size = navigationController?.navigationBar.frame.height else {
            return
        }
        let resizedImage = image.resizeImage(targetSize: CGSize(width: size, height: size))
        let backButton = UIBarButtonItem(image: resizedImage, style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = UIColor.neutralUltraDark
        navigationItem.leftBarButtonItem = backButton

        searchBar.placeholder = "Hãy nhập tìm kiếm"
        searchBar.delegate = self
        searchBar.becomeFirstResponder()

        navigationItem.titleView = searchBar
    }

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: false)
    }

    private func setupBinding() {
        viewModel.$historyResponse
            .sink { [weak self] _ in
                self?.historyCollectionView.reloadData()
            }.store(in: &viewModel.cancellables)

        viewModel.$filterSearchResponse
            .sink { [weak self] filterSearchResponse in
                guard let shoesCollectionView = self?.shoesCollectionView else { return }
                self?.view.bringSubviewToFront(shoesCollectionView)
                self?.shoesCollectionView.reloadData()
                if filterSearchResponse?.data.count == 0 {
                    guard let iconNil = self?.iconNil else { return }
                    self?.view.bringSubviewToFront(iconNil)
                    self?.iconNil.isHidden = false
                } else {
                    self?.iconNil.isHidden = true
                }
            }.store(in: &viewModel.cancellables)
    }

    private func setupCollectionView() {
        historyCollectionView.registerCell(cellType: HistoryCollectionViewCell.self)
        shoesCollectionView.registerCell(cellType: ProductCollectionViewCell.self)
        historyCollectionView.delegate = self
        historyCollectionView.dataSource = self
        shoesCollectionView.delegate = self
        shoesCollectionView.dataSource = self
    }
}

extension SearchHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        if collectionView == historyCollectionView {
            return viewModel.historyResponse?.data.count ?? 0
        } else {
            return viewModel.filterSearchResponse?.data.count ?? 0
        }
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width

        if collectionView == historyCollectionView {
            return CGSize(width: collectionViewWidth - 32, height: 30)
        } else {
            return CGSize(width: (collectionViewWidth / 2) - 32, height: 268)
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == historyCollectionView {
            let cell = collectionView.dequeueReusableCell(withType: HistoryCollectionViewCell.self, for: indexPath)
            if let data = viewModel.historyResponse?.data[indexPath.row] {
                cell.setupCell(historyData: data)
                cell.deleteAction = { [weak self] in
                    self?.viewModel.deleteHistory(idHistory: data.id)
                }
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withType: ProductCollectionViewCell.self, for: indexPath)
            if let shoes = viewModel.filterSearchResponse?.data[indexPath.row] {
                cell.setupCollectionView(shoes: shoes)
                cell.delegate = self
            }
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == historyCollectionView {
            if let data = viewModel.historyResponse?.data[indexPath.row] {
                searchBar.text = data.keyword
                viewModel.searchShoes(search: data.keyword)
                searchBar.endEditing(true)
            }
        } else {
            if let shoes = viewModel.filterSearchResponse?.data[indexPath.row] {
                coordinator?.goToShoesDetail(idShoes: shoes.id)
            }
        }
    }
}

extension SearchHomeViewController: UISearchBarDelegate {
    func searchBar(_: UISearchBar, textDidChange _: String) {
        print("123")
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let texKey = searchBar.text {
            viewModel.searchShoes(search: texKey)
            viewModel.postHistory(keyWord: texKey)
        }
    }

    func searchBarTextDidBeginEditing(_: UISearchBar) {
        view.bringSubviewToFront(historyCollectionView)
    }
}

extension SearchHomeViewController: ProductCollectionViewCellDelegate {
    func didTapFavButton(shoes: ShoeData) {
        if TokenManager.shared.getAccessToken() == nil {
            showToast(message: "Đăng nhập mới có thể sử dụng tính năng này", chooseImageToast: .warning)
            return
        } else {
            viewModel.toggleFav(shoes: shoes)
        }
    }
}
