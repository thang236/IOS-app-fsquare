//
//  ChooseLocationViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 12/11/2024.
//

import Combine
import UIKit

enum ChooseLocationType: String {
    case provinces = "Chọn Tỉnh/Thành phố"
    case district = "Chọn Quận/Huyện"
    case ward = "Chọn Phường/Xã"
}

protocol Location {
    var id: Int { get }
    var name: String { get }
}

struct Province: Location {
    var id: Int
    var name: String
}

struct District: Location {
    var id: Int
    var name: String
}

struct Ward: Location {
    var id: Int
    var name: String
}

class ChooseLocationViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var locationLBL: HeadingLabel!
    private var chooseLocationType: ChooseLocationType?

    private var viewModel: AddressViewModel?
    private var contentData: [Location] = []
    private var filteredData: [Location] = []
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: AddressViewModel, chooseLocationType: ChooseLocationType) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.chooseLocationType = chooseLocationType
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBinding()
        setupNav()
    }

    private func getData() {
        switch chooseLocationType {
        case .provinces:
            viewModel?.getProvinces()
        case .district:
            viewModel?.getDistricts()
        case .ward:
            viewModel?.getWards()
        case .none:
            navigationController?.popViewController(animated: true)
        }
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
        navigationItem.leftBarButtonItem = backButton

        let searchBar = UISearchBar()
        searchBar.placeholder = "Tìm kiếm"
        searchBar.delegate = self
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
    }

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    override func viewWillAppear(_: Bool) {
        getData()
        tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewWillDisappear(_: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = false
    }

    private func setupBinding() {
        switch chooseLocationType {
        case .provinces:
            viewModel?.$provinces
                .receive(on: DispatchQueue.main)
                .sink { [weak self] provinces in
                    guard let self = self, let provinces = provinces else { return }
                    self.contentData = provinces.data.map { Province(id: $0.provinceID, name: $0.provinceName) }
                    self.filteredData = self.contentData
                    self.tableView.reloadData()
                }
                .store(in: &cancellables)
        case .district:
            viewModel?.$districts
                .receive(on: DispatchQueue.main)
                .sink { [weak self] districts in
                    guard let self = self, let districts = districts else { return }
                    self.contentData = districts.data.map { District(id: $0.districtID, name: $0.districtName) }
                    self.filteredData = self.contentData
                    self.tableView.reloadData()
                }
                .store(in: &cancellables)
        case .ward:
            viewModel?.$wards
                .receive(on: DispatchQueue.main)
                .sink { [weak self] wards in
                    guard let self = self, let wards = wards else { return }
                    self.contentData = wards.data.map { Ward(id: Int($0.wardCode) ?? 0, name: $0.wardName) }
                    self.filteredData = self.contentData
                    self.tableView.reloadData()
                }
                .store(in: &cancellables)
        case .none:
            break
        }
        viewModel?.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main).sink { [weak self] errorMessage in
                self?.showToast(message: errorMessage, chooseImageToast: .warning)
                self?.viewModel?.errorMessage = nil
            }.store(in: &cancellables)
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
}

extension ChooseLocationViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return filteredData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = filteredData[indexPath.row].name
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_: UITableView, titleForHeaderInSection _: Int) -> String? {
        return chooseLocationType?.rawValue
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        switch chooseLocationType {
        case .provinces:
            viewModel.provinceID = filteredData[indexPath.row].id
            viewModel.provinceName = filteredData[indexPath.row].name
        case .district:
            viewModel.districtID = filteredData[indexPath.row].id
            viewModel.districtName = filteredData[indexPath.row].name
        case .ward:
            viewModel.wardID = filteredData[indexPath.row].id
            viewModel.wardName = filteredData[indexPath.row].name
        case .none:
            break
        }
        navigationController?.popViewController(animated: false)
    }
}

extension ChooseLocationViewController: UISearchBarDelegate {
    func removeVietnameseDiacritics(_ string: String) -> String {
        let mutableString = NSMutableString(string: string) as CFMutableString
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        return mutableString as String
    }

    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredData = contentData
        } else {
            let searchTextWithoutDiacritics = removeVietnameseDiacritics(searchText.lowercased())
            filteredData = contentData.filter {
                let nameWithoutDiacritics = removeVietnameseDiacritics($0.name.lowercased())
                return nameWithoutDiacritics.contains(searchTextWithoutDiacritics)
            }
        }
        tableView.reloadData()
    }
}
