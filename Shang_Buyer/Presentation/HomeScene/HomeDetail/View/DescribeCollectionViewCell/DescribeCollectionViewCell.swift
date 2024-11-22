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
    @IBOutlet private var soldLbl: UILabel!

    @IBOutlet var rattingLbl: BodyLabel!

    @IBOutlet var favIcon: UIImageView!

    @IBOutlet var starImage1: UIImageView!
    @IBOutlet var starImage2: UIImageView!
    @IBOutlet var starImage5: UIImageView!
    @IBOutlet var starImage4: UIImageView!
    @IBOutlet var starImage3: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        soldLbl.layer.backgroundColor = UIColor.neutralGrayMedium.cgColor
        soldLbl.layer.cornerRadius = 5
        soldLbl.layer.masksToBounds = true
        soldLbl.textAlignment = .center

        descriptionLbl.showGradientSkeleton(delay: 0.25)
        titleLabel.showGradientSkeleton(delay: 0.25)
        soldLbl.showGradientSkeleton(delay: 0.25)
        rattingLbl.showGradientSkeleton(delay: 0.25)
        favIcon.showGradientSkeleton(delay: 0.25)
        starImage1.showGradientSkeleton(delay: 0.25)
        starImage2.showGradientSkeleton(delay: 0.25)
        starImage3.showGradientSkeleton(delay: 0.25)
        starImage4.showGradientSkeleton(delay: 0.25)
        starImage5.showGradientSkeleton(delay: 0.25)
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

    func configureCell(shoesDetailData: ShoesDetailData) {
        descriptionLbl.hideSkeleton()
        titleLabel.hideSkeleton()
        soldLbl.hideSkeleton()
        rattingLbl.hideSkeleton()
        favIcon.hideSkeleton()

        titleLabel.text = shoesDetailData.name
        descriptionLbl.text = shoesDetailData.describe

        setUpRating(ratingNumber: shoesDetailData.rating)
        rattingLbl.text = "\(shoesDetailData.rating)"
        soldLbl.text = "\(shoesDetailData.sales) Sold"

        if shoesDetailData.isFavorite ?? false {
            favIcon.image = UIImage.fav
        } else {
            favIcon.image = UIImage.notFav
        }
    }
}
