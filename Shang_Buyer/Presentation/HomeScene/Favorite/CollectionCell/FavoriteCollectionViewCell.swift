//
//  FavoriteCollectionViewCell.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 20/11/2024.
//

import UIKit

protocol FavoriteCollectionViewCellDelegate: AnyObject {
    func didTapFavButton(favorite: FavoriteData)
}

class FavoriteCollectionViewCell: UICollectionViewCell {
    var delegate: FavoriteCollectionViewCellDelegate?
    @IBOutlet private var favButton: UIButton!
    @IBOutlet private var priceLabel: BodyLabel!
    @IBOutlet private var quantitySoldLabel: BodyLabel!
    @IBOutlet private var numberStart: BodyLabel!
    @IBOutlet private var startProduct: UIImageView!
    @IBOutlet private var nameProduct: BodyLabel!
    @IBOutlet private var productImageView: UIImageView!
    private var favorite: FavoriteData?

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

    func setupCollectionView(favorite: FavoriteData?) {
        if let favorite = favorite {
            self.favorite = favorite

            favButton.setImage(.fav, for: .normal)

            hideSkeleton()
            quantitySoldLabel.text = "\(favorite.sales) sold"
            numberStart.text = "\(favorite.avgRating)"
            nameProduct.text = favorite.name
            if let url = URL(string: favorite.thumbnail.url) {
                productImageView.loadImageWithShimmer(url: url)
            }
            if favorite.avgRating == 0 {
                startProduct.image = UIImage(systemName: "star")
            } else if favorite.avgRating == 5 {
                startProduct.image = UIImage(systemName: "star.fill")
            } else {
                startProduct.image = UIImage(systemName: "star.leadinghalf.filled")
            }
            priceLabel.text = "$\(favorite.minPrice)"
        } else {
            showAnimatedGradientSkeleton()
        }
    }

    @IBAction func didTapFavButton(_: Any) {
        guard let delegate = delegate else { return }
        delegate.didTapFavButton(favorite: favorite!)
    }
}