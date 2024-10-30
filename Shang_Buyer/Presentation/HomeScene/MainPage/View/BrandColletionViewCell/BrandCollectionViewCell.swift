//
//  BrandCollectionViewCell.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 11/10/2024.
//

import UIKit

class BrandCollectionViewCell: UICollectionViewCell {
    @IBOutlet var bannerImageView: UIImageView!

    @IBOutlet var namebrand: UILabel!
//    @IBOutlet weak var roundView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        bannerImageView.layer.cornerRadius = 20
        bannerImageView.clipsToBounds = true

        bannerImageView.isSkeletonable = true
        namebrand.isSkeletonable = true
    }

    func setupBrandCollectionView(brand: BrandItem) {
        hideSkeleton()
        if let url = URL(string: brand.thumbnail.url) {
            bannerImageView.loadImageWithShimmer(url: url)
        }

        namebrand.text = brand.name
    }
}
