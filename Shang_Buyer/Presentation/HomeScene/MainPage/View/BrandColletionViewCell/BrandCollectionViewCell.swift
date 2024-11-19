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

    override func awakeFromNib() {
        super.awakeFromNib()
        bannerImageView.isSkeletonable = true
        namebrand.isSkeletonable = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Bo góc chỉ khi bannerImageView đã có kích thước cụ thể
        bannerImageView.layer.cornerRadius = bannerImageView.frame.size.width / 2
        bannerImageView.clipsToBounds = true
    }

    func setupBrandCollectionView(url: String, nameBrand: String) {
        hideSkeleton()
        if let url = URL(string: url) {
            bannerImageView.loadImageWithShimmer(url: url)
        }
        namebrand.text = nameBrand
    }
}
