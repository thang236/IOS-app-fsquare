//
//  BrandCollectionViewCell.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 11/10/2024.
//

import SkeletonView
import UIKit

class BrandCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var bannerImageView: UIImageView!
    @IBOutlet private var namebrand: UILabel!
    @IBOutlet private var imageViewParent: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        namebrand.isSkeletonable = true
        imageViewParent.isSkeletonable = true
        bannerImageView.isSkeletonable = true
        contentView.isSkeletonable = true
        contentView.showAnimatedGradientSkeleton()
        DispatchQueue.main.async {
            self.imageViewParent.layer.cornerRadius = self.imageViewParent.frame.size.width / 2
            self.imageViewParent.clipsToBounds = true
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    func setupBrandCollectionView(url: String?, nameBrand: String) {
        if nameBrand != "" {
            hideSkeleton()
            if let urlString = url, let url = URL(string: urlString) {
                bannerImageView.loadImageWithShimmer(url: url)
            }
            namebrand.text = nameBrand

        } else {
            showAnimatedGradientSkeleton()
        }
    }
}
