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

    private func setUpRatting(rattingNumber: Double) {
        let starImages = [starImage1, starImage2, starImage3, starImage4, starImage5]
        for i in 0 ..< 5 {
            starImages[i]?.hideSkeleton()
            starImages[i]?.image = UIImage(systemName: "star")
        }

        if rattingNumber == 0 {
        } else if rattingNumber > 0 && rattingNumber < 1 {
            starImages[0]?.image = UIImage(systemName: "star.leadinghalf.fill")
        } else if rattingNumber == 1 {
            starImages[0]?.image = UIImage(systemName: "star.fill")
        } else if rattingNumber > 1 && rattingNumber < 2 {
            starImages[0]?.image = UIImage(systemName: "star.fill")
            starImages[1]?.image = UIImage(systemName: "star.leadinghalf.fill")
        } else if rattingNumber == 2 {
            starImages[0]?.image = UIImage(systemName: "star.fill")
            starImages[1]?.image = UIImage(systemName: "star.fill")
        } else if rattingNumber > 2 && rattingNumber < 3 {
            starImages[0]?.image = UIImage(systemName: "star.fill")
            starImages[1]?.image = UIImage(systemName: "star.fill")
            starImages[2]?.image = UIImage(systemName: "star.leadinghalf.fill")
        } else if rattingNumber == 3 {
            starImages[0]?.image = UIImage(systemName: "star.fill")
            starImages[1]?.image = UIImage(systemName: "star.fill")
            starImages[2]?.image = UIImage(systemName: "star.fill")
        } else if rattingNumber > 3 && rattingNumber < 4 {
            starImages[0]?.image = UIImage(systemName: "star.fill")
            starImages[1]?.image = UIImage(systemName: "star.fill")
            starImages[2]?.image = UIImage(systemName: "star.fill")
            starImages[3]?.image = UIImage(systemName: "star.leadinghalf.fill")
        } else if rattingNumber == 4 {
            starImages[0]?.image = UIImage(systemName: "star.fill")
            starImages[1]?.image = UIImage(systemName: "star.fill")
            starImages[2]?.image = UIImage(systemName: "star.fill")
            starImages[3]?.image = UIImage(systemName: "star.fill")
        } else if rattingNumber > 4 && rattingNumber < 5 {
            starImages[0]?.image = UIImage(systemName: "star.fill")
            starImages[1]?.image = UIImage(systemName: "star.fill")
            starImages[2]?.image = UIImage(systemName: "star.fill")
            starImages[3]?.image = UIImage(systemName: "star.fill")
            starImages[4]?.image = UIImage(systemName: "star.leadinghalf.fill")
        } else if rattingNumber == 5 {
            starImages[0]?.image = UIImage(systemName: "star.fill")
            starImages[1]?.image = UIImage(systemName: "star.fill")
            starImages[2]?.image = UIImage(systemName: "star.fill")
            starImages[3]?.image = UIImage(systemName: "star.fill")
            starImages[4]?.image = UIImage(systemName: "star.fill")
        }
    }

    func configureCell(title: String, ratting: Double, describe: String, isFav: Bool) {
        descriptionLbl.hideSkeleton()
        titleLabel.hideSkeleton()
        soldLbl.hideSkeleton()
        rattingLbl.hideSkeleton()
        favIcon.hideSkeleton()

        titleLabel.text = title
        descriptionLbl.text = describe
        soldLbl.layer.backgroundColor = UIColor.neutralGrayMedium.cgColor
        soldLbl.layer.cornerRadius = 5
        soldLbl.layer.masksToBounds = true
        soldLbl.textAlignment = .center
        setUpRatting(rattingNumber: ratting)
        rattingLbl.text = "\(ratting)  |"
        soldLbl.text = "1000 Sold"
        if isFav {
            favIcon.image = UIImage.fav
        } else {
            favIcon.image = UIImage.notFav
        }
    }
}
