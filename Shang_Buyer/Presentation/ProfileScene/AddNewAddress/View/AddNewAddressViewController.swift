import UIKit

class AddNewAddressViewController: UIViewController {
    var coordinator: ProfileCoordinator?
    @IBOutlet var titleField: NormalField!
    @IBOutlet var cityField: NormalField!
    @IBOutlet var districtField: NormalField!
    @IBOutlet var wardField: NormalField!
    @IBOutlet var streetField: NormalField!
    private var viewModel: AddressViewModel?

    init(viewModel: AddressViewModel) {
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
        setupField()
    }

    private func setupField() {
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

    private func setupNav() {
        navigationItem.hidesBackButton = true
        let image: UIImage = #imageLiteral(resourceName: "positionLeft")
        guard let size = navigationController?.navigationBar.frame.height else {
            return
        }
        let resizedImage = image.resizeImage(targetSize: CGSize(width: size, height: size))
        let backButton = UIBarButtonItem(image: resizedImage, style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .neutralUltraDark
        setupNavigationBar(leftBarButton: backButton, title: "Thêm Địa Chỉ Mới", rightBarButton: nil)
    }

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    override func viewWillAppear(_: Bool) {
        tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(false, animated: true)
        guard let viewModel = viewModel else { return }
        if let city = viewModel.provinceName {
            cityField.text = city
        } else {
            cityField.text = ""
        }

        if let district = viewModel.districtName {
            districtField.text = district
        } else {
            districtField.text = ""
        }

        if let ward = viewModel.wardName {
            wardField.text = ward
        } else {
            wardField.text = ""
        }
    }

    override func viewWillDisappear(_: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = false
    }

    @IBAction func didTapSubmit(_: Any) {
        guard let title = titleField.text, !title.isEmpty,
              let city = cityField.text, !city.isEmpty,
              let district = districtField.text, !district.isEmpty,
              let ward = wardField.text, !ward.isEmpty,
              let street = streetField.text, !street.isEmpty
        else {
            showToast(message: "Please fill all fields", chooseImageToast: .warning)
            return
        }

        let address = AddressData(
            id: "",
            title: title,
            address: street,
            wardName: ward,
            districtName: district,
            provinceName: city,
            isDefault: false
        )

        viewModel?.addLocation(location: address, completion: { [weak self] result in
            switch result {
            case let .success(success):
                print(success.message)
                self?.navigationController?.popViewController(animated: true)

            case let .failure(failure):
                self?.showToast(message: "Something went wrong, please try again", chooseImageToast: .warning)
            }
        })
    }
}

extension AddNewAddressViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
        if textField == cityField, textField == districtField, textField == wardField {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }

    @objc private func cityFieldTapped() {
        guard let coordinator = coordinator, let viewModel = viewModel else {
            return
        }
        coordinator.goToChooseLocation(viewModel: viewModel, chooseLocationType: .provinces)
    }

    @objc private func districtFieldTapped() {
        guard let coordinator = coordinator, let viewModel = viewModel else {
            return
        }
        if let provinceID = viewModel.provinceID, provinceID != 0 {
            coordinator.goToChooseLocation(viewModel: viewModel, chooseLocationType: .district)
        } else {
            showToast(message: "Please choose province before", chooseImageToast: .warning)
        }
    }

    @objc private func wardFieldTapped() {
        guard let coordinator = coordinator, let viewModel = viewModel else {
            return
        }
        if let districtID = viewModel.districtID {
            coordinator.goToChooseLocation(viewModel: viewModel, chooseLocationType: .ward)
        } else {
            showToast(message: "Please choose province and district before", chooseImageToast: .warning)
        }
    }
}
