//
//  OrderListCollectionViewCell.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 30/11/2024.
//

import UIKit

class OrderListCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var priceLabel: BodyLabel!
    @IBOutlet private var nameLabel: BodyLabel!
    @IBOutlet private var sizeLabel: BodyLabel!
    @IBOutlet private var colorLabel: BodyLabel!
    @IBOutlet var actionButton: UIButton!

    private var statusOrder: OderStatusData?
    var didTapAction: ((_ statusOrder: OderStatusData) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        DispatchQueue.main.async {
            self.layer.backgroundColor = UIColor.white.cgColor
            self.layer.shadowColor = UIColor.borderDark.cgColor
            self.layer.shadowOffset = CGSize(width: 2.0, height: 10.0)
            self.layer.shadowRadius = 12
            self.layer.shadowOpacity = 0.5
            self.layer.masksToBounds = false

            self.layer.cornerRadius = 12
        }

        contentView.isSkeletonable = true
        contentView.showAnimatedGradientSkeleton()
    }

    override func layoutSubviews() {
        // Initialization code
    }

    func setupCell(oderStatusData: OderStatusData?) {
        if let item = oderStatusData?.firstOrderItem {
            statusOrder = oderStatusData
            contentView.hideSkeleton()
            if let urlString = item.thumbnail?.url, let url = URL(string: urlString) {
                imageView.loadImageWithShimmer(url: url)
            }
            if oderStatusData?.status == "pending" {
                actionButton.setTitle("Hủy đơn", for: .normal)
                actionButton.isHidden = false
            } else if oderStatusData?.status == "delivered" {
                actionButton.setTitle("Đã nhận", for: .normal)
                actionButton.isHidden = false
            } else if oderStatusData?.status == "confirmed" {
                if oderStatusData?.isReview ?? false {
                    actionButton.isHidden = true
                } else {
                    actionButton.setTitle("Đánh giá", for: .normal)
                    actionButton.isHidden = false
                }
            } else {
                actionButton.isHidden = true
            }

            guard let data = oderStatusData else { return }

            nameLabel.text = "Mã đơn: \(data.clientOrderCode)"

            let totalPrice = data.codAmount + data.shippingFee
            let priceString = NumberFormatter.formatToVNDWithCustomSymbol(totalPrice)
            priceLabel.text = priceString
            guard let productSamplesCount = data.productSamplesCount, let totalQuantity = data.totalQuantity else { return }
            colorLabel.text = "Số loại hàng: \(String(describing: productSamplesCount))"
            sizeLabel.text = "Tổng số lượng: \(String(describing: totalQuantity))"
        } else {
            showAnimatedGradientSkeleton()
        }
    }

    @IBAction func didTapAction(_: Any) {
        guard let statusOrder = statusOrder else { return }
        didTapAction?(statusOrder)
    }
}
