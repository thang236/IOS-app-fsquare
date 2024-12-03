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
    var coordinator: ProfileCoordinator?

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
        setupBinding()
    }

    private func setupField() {
        titleField.text = address.title
        cityField.text = address.provinceName
        districtField.text = address.districtName
        wardField.text = address.wardName
        streetField.text = address.address
        isDefaultSwitch.isOn = address.isDefault

        cityField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cityFieldTapped))
        cityField.addGestureRecognizer(tapGesture)

        districtField.delegate = self
        let tapDistrictGesture = UITapGestureRecognizer(target: self, action: #selector(districtFieldTapped))
        districtField.addGestureRecognizer(tapDistrictGesture)

        wardField.delegate = self
        let tapWardGesture = UITapGestureRecognizer(target: self, action: #selector(wardFieldTapped))
        wardField.addGestureRecognizer(tapWardGesture)
    }

    @IBAction func didTapIsDefaultButton(_: Any) {
        if !isDefaultSwitch.isOn {
            showToast(message: "This address is is default you must set default other address", chooseImageToast: .warning)
            isDefaultSwitch.setOn(true, animated: false)
        }
    }

    private func setupBinding() {
        viewModel.$provinceName
            .compactMap { $0 }
            .sink { [weak self] provinceName in
                self?.cityField.text = provinceName
            }.store(in: &viewModel.cancellables)

        viewModel.$districtName
            .compactMap { $0 }
            .sink { [weak self] districtName in
                self?.districtField.text = districtName
            }.store(in: &viewModel.cancellables)

        viewModel.$wardName
            .compactMap { $0 }
            .sink { [weak self] wardName in
                self?.wardField.text = wardName
            }.store(in: &viewModel.cancellables)
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
        setupNavigationBar(leftBarButton: backButton, title: "Chỉnh sửa địa chỉ", rightBarButton: nil)
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

        if viewModel.provinceName != nil {
            if viewModel.districtName == nil || viewModel.wardName == nil {
                showToast(message: "Vui Lòng chọn lại địa chỉ", chooseImageToast: .warning)
            } else {
                address.title = title
                address.address = street
                address.districtName = district
                address.provinceName = city
                address.wardName = ward
                address.isDefault = isDefaultSwitch.isOn
                editAddress()
            }
        } else {
            address.title = title
            address.address = street
            address.districtName = district
            address.provinceName = city
            address.wardName = ward
            address.isDefault = isDefaultSwitch.isOn
            editAddress()
        }
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

extension EditAddressViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
        if textField == cityField, textField == districtField, textField == wardField {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }

    @objc private func cityFieldTapped() {
        guard let coordinator = coordinator else {
            return
        }
        coordinator.goToChooseLocation(viewModel: viewModel, chooseLocationType: .provinces)
    }

    @objc private func districtFieldTapped() {
        guard let coordinator = coordinator else {
            return
        }
        if let provinceID = viewModel.provinceID, provinceID != 0 {
            coordinator.goToChooseLocation(viewModel: viewModel, chooseLocationType: .district)
        } else {
            showToast(message: "Vui lòng hãy chọn lại tỉnh, thành", chooseImageToast: .warning)
        }
    }

    @objc private func wardFieldTapped() {
        guard let coordinator = coordinator else {
            return
        }
        if let districtID = viewModel.districtID {
            coordinator.goToChooseLocation(viewModel: viewModel, chooseLocationType: .ward)
        } else {
            showToast(message: "Vui lòng chọn tỉnh/thành và quận/huyện trước", chooseImageToast: .warning)
        }
    }
}
