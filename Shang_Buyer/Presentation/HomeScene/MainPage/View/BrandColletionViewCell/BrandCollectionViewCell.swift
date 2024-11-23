//
//  BrandCollectionViewCell.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 11/10/2024.
//

import UIKit
import SkeletonView

class BrandCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var bannerImageView: UIImageView!
    @IBOutlet private weak var namebrand: UILabel!
    @IBOutlet private weak var imageViewParent: UIView!
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
        if  nameBrand != "" {
            if let urlString = url, let url = URL(string: urlString) {
                if urlString == "more" {
                    bannerImageView.image = UIImage(systemName: "ellipsis")
                } else {
                    bannerImageView.loadImageWithShimmer(url: url)
                }
            }
            hideSkeleton()
        } else {
            showAnimatedGradientSkeleton()
        }
        namebrand.text = nameBrand

        
    }
}
