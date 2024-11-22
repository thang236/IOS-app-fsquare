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

        imageView.layer.cornerRadius = 14
        imageView.layer.masksToBounds = true

        contentView.layer.cornerRadius = 14
        contentView.layer.masksToBounds = true

        layer.cornerRadius = 14
        layer.masksToBounds = true
    }

    func setupCell(title: String, price: String) {
        nameShoes.text = title
        self.price.text = price
    }
}
