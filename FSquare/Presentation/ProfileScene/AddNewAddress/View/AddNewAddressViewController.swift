import UIKit

class AddNewAddressViewController: UIViewController {
    var coordinator: ProfileCoordinator?
    @IBOutlet var titleField: NormalField!
    @IBOutlet var cityField: NormalField!
    @IBOutlet var districtField: NormalField!
    @IBOutlet var wardField: NormalField!
    @IBOutlet var streetField: NormalField!
    private var viewModel: AddressViewModel

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
        setupBinding()
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

    private func setupBinding() {
        viewModel.$provinceName
            .sink { [weak self] provinceName in
                self?.cityField.text = provinceName
                self?.districtField.text = ""
                self?.wardField.text = ""
            }.store(in: &viewModel.cancellables)

        viewModel.$districtName
            .sink { [weak self] districtName in
                self?.districtField.text = districtName
                self?.wardField.text = ""
            }.store(in: &viewModel.cancellables)

        viewModel.$wardName
            .sink { [weak self] wardName in
                self?.wardField.text = wardName
            }.store(in: &viewModel.cancellables)

        viewModel.$errorMessage
            .sink { [weak self] errorMessage in
                if let errorMessage = errorMessage {
                    self?.showToast(message: errorMessage, chooseImageToast: .warning)
                    self?.viewModel.errorMessage = nil
                }
            }.store(in: &viewModel.cancellables)
    }

    override func viewWillAppear(_: Bool) {
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_: Bool) {
        tabBarController?.tabBar.isHidden = false
    }

    @IBAction func didTapSubmit(_: Any) {
        guard let title = titleField.text, !title.isEmpty,
              let city = cityField.text, !city.isEmpty,
              let district = districtField.text, !district.isEmpty,
              let ward = wardField.text, !ward.isEmpty,
              let street = streetField.text, !street.isEmpty
        else {
            showToast(message: "Vui lòng hãy điền đủ tất cả các trường", chooseImageToast: .warning)
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

        viewModel.addLocation(location: address, completion: { [weak self] result in
            switch result {
            case let .success(success):
                print(success.message)
                self?.navigationController?.popViewController(animated: true)

            case let .failure(failure):
                self?.showToast(message: "Đã có lỗi xảy ra, vui lòng thử lại", chooseImageToast: .warning)
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
            showToast(message: "Bạn phải chọn tỉnh, thành phố trước", chooseImageToast: .warning)
        }
    }

    @objc private func wardFieldTapped() {
        guard let coordinator = coordinator else {
            return
        }
        if let districtID = viewModel.districtID {
            coordinator.goToChooseLocation(viewModel: viewModel, chooseLocationType: .ward)
        } else {
            showToast(message: "Vui lòng chọn quận, huyện trước", chooseImageToast: .warning)
        }
    }
}
