//
//  OrderListBagCollectionViewCell.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 04/12/2024.
//

import UIKit

class OrderListBagCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var quantityLabel: BodyLabel!
    @IBOutlet var priceLabel: BodyLabel!
    @IBOutlet var sizeLabel: BodyLabel!
    @IBOutlet var colorLabel: BodyLabel!
    @IBOutlet var quantityView: UIView!
    @IBOutlet var nameLabel: BodyLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        quantityView.layer.cornerRadius = quantityView.frame.width / 2
        quantityView.layer.masksToBounds = true

        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true

        contentView.isSkeletonable = true
        contentView.showAnimatedGradientSkeleton()
    }

    func setupCell(orderItems: OrderItem?) {
        if let orderItems = orderItems {
            hideSkeleton()
            priceLabel.text = NumberFormatter.formatToVNDWithCustomSymbol(orderItems.price * Double(orderItems.quantity))
            nameLabel.text = orderItems.shoes
            sizeLabel.text = "Size = \(orderItems.size)"
            colorLabel.text = orderItems.color
            quantityLabel.text = "\(orderItems.quantity)"
            if let urlString = orderItems.thumbnail?.url, let url = URL(string: urlString) {
                imageView.loadImageWithShimmer(url: url)
            }
        } else {
            showAnimatedGradientSkeleton()
        }
    }
}
