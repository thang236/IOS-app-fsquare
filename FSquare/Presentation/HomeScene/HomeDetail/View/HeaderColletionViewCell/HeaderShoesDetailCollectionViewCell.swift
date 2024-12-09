//
//  HeaderShoesDetailCollectionViewCell.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 31/10/2024.
//

import SkeletonView
import UIKit

class HeaderShoesDetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageView.showGradientSkeleton(delay: 0.25)
    }

    func configureCell(image: String?) {
        imageView.hideSkeleton()
        if let urlString = image, let url = URL(string: urlString) {
            imageView.kf.setImage(with: url)
        } else {
            imageView.image = UIImage.shoesshimmerPDF
        }
    }
}
