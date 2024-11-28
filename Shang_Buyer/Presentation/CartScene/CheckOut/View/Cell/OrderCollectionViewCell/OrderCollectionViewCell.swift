//
//  OrderCollectionViewCell.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 24/11/2024.
//

import UIKit

class OrderCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var quantityLabel: BodyLabel!
    @IBOutlet var priceLabel: BodyLabel!
    @IBOutlet var sizeLabel: BodyLabel!
    @IBOutlet var colorLabel: BodyLabel!
    @IBOutlet var colorView: UIView!
    @IBOutlet var quantityView: UIView!
    @IBOutlet var nameLabel: BodyLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        colorView.layer.cornerRadius = colorView.frame.width / 2
        colorView.layer.masksToBounds = true

        quantityView.layer.cornerRadius = quantityView.frame.width / 2
        quantityView.layer.masksToBounds = true

        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true

        contentView.isSkeletonable = true
        contentView.showAnimatedGradientSkeleton()
    }

    func setupCell(bag: BagData?) {
        if let bag = bag {
            hideSkeleton()
            priceLabel.text = NumberFormatter.formatToVNDWithCustomSymbol(bag.price * Double(bag.quantity))
            nameLabel.text = bag.shoes?.name
            sizeLabel.text = bag.size?.sizeNumber
            colorLabel.text = bag.color
            quantityLabel.text = "\(bag.quantity)"
            if let urlString = bag.thumbnail?.url, let url = URL(string: urlString) {
                imageView.loadImageWithShimmer(url: url)
            }
        } else {
            showAnimatedGradientSkeleton()
        }
    }
}
