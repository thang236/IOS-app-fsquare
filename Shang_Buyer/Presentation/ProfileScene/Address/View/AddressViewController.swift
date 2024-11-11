//
//  AddressViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 08/10/2024.
//

import Combine
import UIKit

class AddressViewController: UIViewController {
    @IBOutlet var bottomView: UIView!

    @IBOutlet var tableView: UITableView!

    private var viewModel: AddressViewModel?
    private var cancellables = Set<AnyCancellable>()
    private var addressDatas: [AddressData] = []
    var coordinator: ProfileCoordinator?

    init(viewModel: AddressViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        bottomView.addShadow()
        setupBinding()
        setupTableView()
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
        setupNavigationBar(leftBarButton: backButton, title: "Address", rightBarButton: nil)
    }

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    override func viewWillAppear(_: Bool) {
        viewModel?.getAddress()
        tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewWillDisappear(_: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = false
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(cellType: AddressTableViewCell.self)
        tableView.separatorColor = .clear
    }

    private func setupBinding() {
        viewModel?.$address
            .receive(on: DispatchQueue.main)
            .sink { [weak self] address in
                guard let address = address else { return }
                self?.addressDatas = address.data.sorted { $0.isDefault && !$1.isDefault }
                self?.tableView.reloadData()
            }.store(in: &cancellables)
    }

    @IBAction func didTapNewAddress(_: Any) {
        guard let coordinator = coordinator, let viewModel = viewModel else {
            return
        }
        coordinator.gotoAddAddress(addressViewModel: viewModel)
    }
}

extension AddressViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 1
    }

    func numberOfSections(in _: UITableView) -> Int {
        return addressDatas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: AddressTableViewCell.self, at: indexPath)
        cell.setupCell(address: addressDatas[indexPath.section])
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeAction = UIContextualAction(style: .normal, title: nil) { _, _, completionHandler in
            self.viewModel?.deleteLocation(idLocation: self.addressDatas[indexPath.section].id, completion: { completion in
                switch completion {
                case .success:
                    if self.addressDatas[indexPath.section].isDefault {
                        self.showToast(message: "this address is default you can't remove", chooseImageToast: .warning)
                    } else {
                        self.addressDatas.remove(at: indexPath.section)
                        self.showToast(message: "Delete address success", chooseImageToast: .success)
                        self.tableView.reloadData()
                    }
                case let .failure(failure):
                    self.showToast(message: failure.localizedDescription, chooseImageToast: .warning)
                }
            })
            completionHandler(true)
        }
        swipeAction.image = UIImage(systemName: "trash")
        swipeAction.backgroundColor = .red

        let swipeActions = UISwipeActionsConfiguration(actions: [swipeAction])
        return swipeActions
    }
}

extension AddressViewController: AddressTableViewCellDelegate {
    func didTapEditButton(address: AddressData) {
        guard let viewModel = viewModel else { return }
        coordinator?.goToEditAddress(viewModel: viewModel, address: address)
    }
}
