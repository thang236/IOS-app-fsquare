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
    @IBOutlet private var quantityLabel: BodyLabel!
    @IBOutlet private var sizeLabel: BodyLabel!
    @IBOutlet private var colorLabel: BodyLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        DispatchQueue.main.async {
            self.layer.backgroundColor = UIColor.white.cgColor
            self.layer.shadowColor = UIColor.borderDark.cgColor
            self.layer.shadowOffset = CGSize(width: 2.0, height: 16.0)
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
            contentView.hideSkeleton()
            if let urlString = item.thumbnail?.url, let url = URL(string: urlString) {
                imageView.loadImageWithShimmer(url: url)
            }
            nameLabel.text = item.shoes
            let priceString = NumberFormatter.formatToVNDWithCustomSymbol(item.price)
            priceLabel.text = priceString
            quantityLabel.text = "Số lượng: \(item.quantity)"
            sizeLabel.text = "Size: \(item.size)"
            colorLabel.text = "\(item.color)"
        } else {
            showAnimatedGradientSkeleton()
        }
    }
}
