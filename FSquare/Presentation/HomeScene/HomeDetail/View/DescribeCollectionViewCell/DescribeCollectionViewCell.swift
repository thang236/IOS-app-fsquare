//
//  DescribeCollectionViewCell.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 05/11/2024.
//

import SkeletonView
import UIKit

class DescribeCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var descriptionLbl: DescriptionLabel!
    @IBOutlet private var titleLabel: HeadingLabel!
    @IBOutlet private var soldLbl: PaddingLabel!

    @IBOutlet var rattingLbl: BodyLabel!

    @IBOutlet var favIcon: UIImageView!

    @IBOutlet var starImage1: UIImageView!
    @IBOutlet var starImage2: UIImageView!
    @IBOutlet var starImage5: UIImageView!
    @IBOutlet var starImage4: UIImageView!
    @IBOutlet var starImage3: UIImageView!

    var action: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapFavIcon))
        favIcon.isUserInteractionEnabled = true
        favIcon.addGestureRecognizer(tapGesture)

        soldLbl.layer.backgroundColor = UIColor.neutralGrayMedium.cgColor
        soldLbl.layer.cornerRadius = 5
        soldLbl.layer.masksToBounds = true
        soldLbl.textAlignment = .center

        contentView.isSkeletonable = true
        contentView.showAnimatedGradientSkeleton()
    }

    private func setUpRating(ratingNumber: Double) {
        let starImages = [starImage1, starImage2, starImage3, starImage4, starImage5]

        let fullStars = Int(ratingNumber)
        let halfStar = (ratingNumber - Double(fullStars)) >= 0.5 ? 1 : 0

        for (index, starImage) in starImages.enumerated() {
            starImage?.image = UIImage(systemName: "star")
            if index < fullStars {
                starImage?.image = UIImage(systemName: "star.fill")
            } else if index == fullStars && halfStar == 1 {
                starImage?.image = UIImage(systemName: "star.leadinghalf.fill")
            }
        }
        for starImage in starImages {
            starImage?.hideSkeleton()
        }
    }

    func configureCell(shoesDetailData: ShoesDetailData?) {
        if let shoesDetailData = shoesDetailData, shoesDetailData.id != "" {
            contentView.hideSkeleton()
            titleLabel.text = shoesDetailData.name
            descriptionLbl.text = shoesDetailData.describe

            setUpRating(ratingNumber: shoesDetailData.rating)
            rattingLbl.text = "\(shoesDetailData.rating)"
            soldLbl.text = "\(shoesDetailData.sales) Đã bán"

            if shoesDetailData.isFavorite ?? false {
                favIcon.image = UIImage.fav
            } else {
                favIcon.image = UIImage.notFav
            }
        } else {
            showAnimatedGradientSkeleton()
        }
    }

    @objc private func didTapFavIcon() {
        action?()
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()

        let size = contentView.systemLayoutSizeFitting(
            CGSize(width: layoutAttributes.frame.width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        layoutAttributes.frame.size = size
        return layoutAttributes
    }
}
