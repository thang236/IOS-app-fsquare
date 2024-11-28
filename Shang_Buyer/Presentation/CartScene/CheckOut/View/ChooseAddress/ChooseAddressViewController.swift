//
//  ChooseAddressViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 26/11/2024.
//

import UIKit

class ChooseAddressViewController: UIViewController {
    @IBOutlet private var bottomView: UIView!
    @IBOutlet private var collectionView: UICollectionView!

    private let viewModel: CartViewModel

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
        setUpBinding()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_: Bool) {
        bottomView.layer.backgroundColor = UIColor.white.cgColor
        bottomView.layer.shadowColor = UIColor.borderDark.cgColor
        bottomView.layer.shadowOffset = CGSize(width: 0.0, height: -4.0)
        bottomView.layer.shadowRadius = 16
        bottomView.layer.shadowOpacity = 0.5
        bottomView.layer.masksToBounds = false

        bottomView.layer.cornerRadius = 16
    }

    override func viewWillDisappear(_: Bool) {}

    private func setUpBinding() {
        viewModel.$addressResponse
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &viewModel.cancellables)

        viewModel.$addressChoose
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &viewModel.cancellables)
    }

    private func setupCollectionView() {
        collectionView.registerCell(cellType: ChooseAddressCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension ChooseAddressViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return viewModel.addressResponse?.data.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withType: ChooseAddressCollectionViewCell.self, for: indexPath)

        let data = viewModel.addressResponse?.data[indexPath.row]
        if data == viewModel.addressChoose {
            cell.setupCell(address: data, isChoose: true)
        } else {
            cell.setupCell(address: data, isChoose: false)
        }

        return cell
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.addressChoose = viewModel.addressResponse?.data[indexPath.row]
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32, height: 84)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16)
    }
}
