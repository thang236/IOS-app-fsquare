//
//  EditAddressViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 12/11/2024.
//

import UIKit

class EditAddressViewController: UIViewController {
    var viewModel: AddressViewModel
    var address: AddressData

    @IBOutlet var titleField: NormalField!
    @IBOutlet var cityField: NormalField!
    @IBOutlet var districtField: NormalField!
    @IBOutlet var wardField: NormalField!
    @IBOutlet var streetField: NormalField!
    @IBOutlet var isDefaultSwitch: UISwitch!
    init(viewModel: AddressViewModel, address: AddressData) {
        self.viewModel = viewModel
        self.address = address
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        setupField()
    }

    private func setupField() {
        titleField.text = address.title
        cityField.text = address.provinceName
        districtField.text = address.districtName
        wardField.text = address.wardName
        streetField.text = address.address
        isDefaultSwitch.isOn = address.isDefault
    }

    @IBAction func didTapIsDefaultButton(_: Any) {
        if !isDefaultSwitch.isOn {
            showToast(message: "This address is is default you must set default other address", chooseImageToast: .warning)
            isDefaultSwitch.setOn(true, animated: false)
        }
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
        setupNavigationBar(leftBarButton: backButton, title: "Edit Address", rightBarButton: nil)
    }

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    override func viewWillAppear(_: Bool) {
        tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewWillDisappear(_: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = false
    }

    @IBAction private func didTapSubmit(_: Any) {
        guard let title = titleField.text, !title.isEmpty,
              let city = cityField.text, !city.isEmpty,
              let district = districtField.text, !district.isEmpty,
              let ward = wardField.text, !ward.isEmpty,
              let street = streetField.text, !street.isEmpty
        else {
            showToast(message: "Please fill all fields", chooseImageToast: .warning)
            return
        }
        address.title = title
        address.address = street
        address.districtName = district
        address.provinceName = city
        address.wardName = ward
        address.isDefault = isDefaultSwitch.isOn
        editAddress()
    }

    private func editAddress() {
        viewModel.editLocation(location: address, completion: { [weak self] result in
            switch result {
            case let .success(success):
                self?.navigationController?.popViewController(animated: true)

            case let .failure(failure):
                self?.showToast(message: failure.localizedDescription, chooseImageToast: .warning)
            }
        })
    }
}
