//
//  NotificationViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 05/12/2024.
//

import UIKit

class NotificationViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    let viewModel: NotificationViewModel

    init(viewModel: NotificationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_: Bool) {
        viewModel.getNotifications()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupBinding()
        setupNav()
    }

    private func setupNav() {
        navigationItem.hidesBackButton = true
        let image: UIImage = #imageLiteral(resourceName: "positionLeft")
        guard let size = navigationController?.navigationBar.frame.height else {
            return
        }
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backButtonTapped))
        button.tintColor = .black
        setupNavigationBar(leftBarButton: button, title: "Thông báo")
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    private func setupBinding() {
        viewModel.$notificationResponse.sink { [weak self] _ in
            self?.collectionView.reloadData()
        }.store(in: &viewModel.cancellables)
    }

    private func setupCollectionView() {
        collectionView.registerCell(cellType: NotificationCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension NotificationViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return viewModel.notificationResponse?.data.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withType: NotificationCollectionViewCell.self, for: indexPath)
        if let notiData = viewModel.notificationResponse?.data[indexPath.row] {
            cell.setupCell(notiData: notiData)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.frame.size.width) - 32
        let height: CGFloat = 88
        return CGSize(width: width, height: height)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16)
    }
}
