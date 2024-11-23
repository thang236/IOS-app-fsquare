//
//  PopularCollectionViewCell.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 12/11/2024.
//

import UIKit

class PopularCollectionViewCell: UICollectionViewCell {
    @IBOutlet var price: HeadingLabel!
    @IBOutlet var nameShoes: HeadingLabel!
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage.backgroundPopular
        iv.contentMode = .scaleAspectFill
        return iv
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundView = imageView
        DispatchQueue.main.async {
            self.imageView.layer.cornerRadius = 14
            self.imageView.layer.masksToBounds = true

            self.contentView.layer.cornerRadius = 14
            self.contentView.layer.masksToBounds = true

            self.layer.cornerRadius = 14
            self.layer.masksToBounds = true
        }

        showAnimatedGradientSkeleton()
    }

    func setupCell(title: String?, price: String?) {
        if let title = title, let price = price, title != "" {
            hideSkeleton()
            nameShoes.text = title
            self.price.text = price
        } else {
            showAnimatedGradientSkeleton()
        }
    }
}
