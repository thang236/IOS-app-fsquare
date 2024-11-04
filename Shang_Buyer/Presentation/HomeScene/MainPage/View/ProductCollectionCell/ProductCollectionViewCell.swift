//
//  ProductCollectionViewCell.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 09/10/2024.
//

import SkeletonView
import UIKit

protocol ProductCollectionViewCellDelegate: AnyObject {
    func didTapFavButton(index: Int)
}

class ProductCollectionViewCell: UICollectionViewCell {
    var delegate: ProductCollectionViewCellDelegate?
    @IBOutlet private var favButton: UIButton!
    @IBOutlet private var priceLabel: BodyLabel!
    @IBOutlet private var quantitySoldLabel: BodyLabel!
    @IBOutlet private var numberStart: BodyLabel!
    @IBOutlet private var startProduct: UIImageView!
    @IBOutlet private var nameProduct: BodyLabel!
    @IBOutlet private var productImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        favButton.layer.cornerRadius = favButton.frame.size.width / 2
        favButton.clipsToBounds = true
        contentView.isSkeletonable = true
        favButton.isSkeletonable = true
        priceLabel.isSkeletonable = true
        quantitySoldLabel.isSkeletonable = true
        numberStart.isSkeletonable = true
        startProduct.isSkeletonable = true
        nameProduct.isSkeletonable = true
        productImageView.isSkeletonable = true

        productImageView.layer.cornerRadius = 10
        productImageView.clipsToBounds = true
        contentView.showAnimatedSkeleton()
    }

    func setupCollectionView(shoes: ShoeData?) {
        if let shoes = shoes {
            hideSkeleton()
            quantitySoldLabel.text = "\(shoes.reviewCount) sold"
            numberStart.text = "\(shoes.rating)"
            nameProduct.text = shoes.name
            if let url = URL(string: shoes.thumbnail.url) {
                productImageView.loadImageWithShimmer(url: url)
            }
            if shoes.rating == 0 {
                startProduct.image = UIImage(systemName: "star")
            } else if shoes.rating == 5 {
                startProduct.image = UIImage(systemName: "star.fill")
            } else {
                startProduct.image = UIImage(systemName: "star.leadinghalf.filled")
            }
            priceLabel.text = "$\(shoes.minPrice)"
        } else {
            showAnimatedGradientSkeleton()
        }
    }

    @IBAction func didTapFavButton(_: Any) {
        guard let delegate = delegate else { return }
//        delegate.didTapFavButton(index: )
    }
}
