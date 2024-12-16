//
//  RattingViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 04/12/2024.
//

import AVKit
import PhotosUI
import ProgressHUD
import UIKit
import UniformTypeIdentifiers

enum MediaItem {
    case image(UIImage)
    case video(URL)
}

protocol RattingViewControllerDelegate {
    func didTapSubmit()
}

class RattingViewController: UIViewController {
    var delegate: RattingViewControllerDelegate?
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tutorialLabel: HeadingLabel!
    private var mediaItems: [MediaItem] = []
    private var oderStatusData: OderStatusData

    @IBOutlet var orderView: UIView!
    @IBOutlet private var imageOrder: UIImageView!
    @IBOutlet private var idClientOrderLabel: BodyLabel!
    @IBOutlet private var priceOrderLabel: BodyLabel!
    @IBOutlet private var quantityOrderLabel: BodyLabel!
    @IBOutlet private var productSamplesCountLabel: BodyLabel!
    @IBOutlet var startRattingView: StarRatingView!

    @IBOutlet var contentField: NormalField!
    init(oderStatusData: OderStatusData) {
        print(oderStatusData)
        self.oderStatusData = oderStatusData
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.cornerRadius = view.frame.width / 8
        setupCollectionView()
        styleView(orderView)
    }

    func styleView(_ view: UIView) {
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = false

        view.layer.shadowColor = UIColor.borderMedium.cgColor
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
    }

    private func setupCollectionView() {
        collectionView.registerCell(cellType: MediaRattingCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        setupView()
    }

    private func setupView() {
        if let url = URL(string: oderStatusData.firstOrderItem?.thumbnail?.url ?? "") {
            imageOrder.loadImageWithShimmer(url: url, placeholderImage: UIImage.imageShimmer)
        }
        idClientOrderLabel.text = oderStatusData.clientOrderCode
        let totalPrice = NumberFormatter.formatToVNDWithCustomSymbol(oderStatusData.codAmount + oderStatusData.shippingFee)
        priceOrderLabel.text = totalPrice
        quantityOrderLabel.text = "tổng số lượng: \(oderStatusData.totalQuantity ?? 0)"
        productSamplesCountLabel.text = "số loại hàng \(oderStatusData.productSamplesCount ?? 0)"
    }

    @IBAction func didTapAddImage(_: Any) {
        var config = PHPickerConfiguration()
        config.selectionLimit = 5
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }

    @IBAction func didTapAddVideo(_: Any) {
        var config = PHPickerConfiguration()
        config.selectionLimit = 5
        config.filter = .videos
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }

    @IBAction func didTapSubmit(_: Any) {
        if mediaItems.isEmpty {
            showToast(message: "Vui lòng chọn ảnh hoặc video", chooseImageToast: .warning)
        } else if contentField.text?.isEmpty == true {
            showToast(message: "Vui lòng nhập nội dung đánh giá", chooseImageToast: .warning)
        } else if mediaItems.count >= 5 {
            showToast(message: "Bạn chỉ có thể chọn tối đa 5 mục", chooseImageToast: .warning)
        } else {
            ProgressHUD.animate("Loading...")
            let orderID = oderStatusData.id
            let files = changeToURLArray()
            let rating = startRattingView.rating
            let content = contentField.text ?? ""
            RatingAPIService.shared.submitRating(orderID: orderID, rating: rating, content: content, files: files) { result in
                switch result {
                case .success:
                    print("Gửi đánh giá thành công!")
                    ProgressHUD.succeed()
                    self.dismiss(animated: true) {
                        self.delegate?.didTapSubmit()
                    }
                case let .failure(error):
                    ProgressHUD.failed()
                    self.showToast(message: "Lỗi khi gửi đánh giá", chooseImageToast: .error)
                    print("Lỗi khi gửi đánh giá: \(error.localizedDescription)")
                }
            }
        }
    }

    @IBAction func didTapClearButton(_: Any) {
        mediaItems.removeAll()
        collectionView.reloadData()
        tutorialLabel.isHidden = false
        contentField.text = ""
    }

    private func changeToURLArray() -> [URL] {
        let files: [URL] = mediaItems.compactMap { item in
            switch item {
            case let .image(image):
                guard let url = saveImageToTemporaryDirectory(image: image) else { return nil }
                return url
            case let .video(videoURL):
                return videoURL
            }
        }
        return files
    }

    private func saveImageToTemporaryDirectory(image: UIImage) -> URL? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        let fileName = UUID().uuidString + ".jpeg"
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        do {
            try data.write(to: tempURL)
            return tempURL
        } catch {
            print("Lỗi khi lưu ảnh: \(error.localizedDescription)")
            return nil
        }
    }
}

extension RattingViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        var selectedImages: [UIImage] = []
        var selectedVideos: [URL] = []

        let dispatchGroup = DispatchGroup()

        for result in results {
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                dispatchGroup.enter()
                result.itemProvider.loadObject(ofClass: UIImage.self) { [self] object, error in
                    if let image = object as? UIImage {
                        mediaItems.append(.image(image))
                        selectedImages.append(image)
                    } else if let error = error {
                        print("Lỗi khi load ảnh: \(error.localizedDescription)")
                    }
                    dispatchGroup.leave()
                }
            }

            if result.itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                dispatchGroup.enter()
                result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { [self] url, error in
                    if let url = url {
                        do {
                            let uniqueFileName = UUID().uuidString + "_" + url.lastPathComponent
                            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(uniqueFileName)
                            try FileManager.default.copyItem(at: url, to: tempURL)
                            mediaItems.append(.video(tempURL))
                            selectedVideos.append(tempURL)
                        } catch {
                            print("Lỗi khi copy file video: \(error.localizedDescription)")
                        }
                    } else if let error = error {
                        print("Lỗi khi load video: \(error.localizedDescription)")
                    }
                    dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            picker.dismiss(animated: true) {
                if !selectedImages.isEmpty {
                    print("Chọn ảnh: \(selectedImages)")
                    self.collectionView.reloadData()
                    if self.mediaItems.count > 0 {
                        self.tutorialLabel.isHidden = true
                    }
                }
                if !selectedVideos.isEmpty {
                    print("Chọn video: \(selectedVideos)")
                    self.collectionView.reloadData()
                    if self.mediaItems.count > 0 {
                        self.tutorialLabel.isHidden = true
                    }
                }
            }
        }
    }

    func pickerDidCancel(_ picker: PHPickerViewController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension RattingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return mediaItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withType: MediaRattingCollectionViewCell.self, for: indexPath)
        cell.setupCell(mediaItem: mediaItems[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.height
        let height: CGFloat = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
}
