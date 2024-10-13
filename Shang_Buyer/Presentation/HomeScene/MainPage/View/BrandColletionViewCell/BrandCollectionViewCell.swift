//
//  BrandCollectionViewCell.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 11/10/2024.
//

import UIKit

class BrandCollectionViewCell: UICollectionViewCell {
    @IBOutlet var bannerImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = frame.size.width / 2
        clipsToBounds = true
    }

    func setupBrandCollectionView(brand: BrandItem) {
        if let url = URL(string: brand.thumbnail.url) {
            bannerImageView.loadImageWithShimmer(url: url)
        }
    }
}
