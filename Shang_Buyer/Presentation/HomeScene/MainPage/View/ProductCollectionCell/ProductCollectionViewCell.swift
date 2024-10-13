//
//  ProductCollectionViewCell.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 09/10/2024.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet var favButton: UIButton!
    @IBOutlet var priceLabel: BodyLabel!
    @IBOutlet var quantitySoldLabel: BodyLabel!
    @IBOutlet var numberStart: BodyLabel!
    @IBOutlet var startProduct: UIImageView!
    @IBOutlet var nameProduct: BodyLabel!
    @IBOutlet var productImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()

        favButton.layer.cornerRadius = favButton.frame.size.width / 2
        favButton.clipsToBounds = true // Cắt bớt phần thừa
    }

    func setupCollectionView(shoes: ShoeData) {
        quantitySoldLabel.text = "\(shoes.reviewCount) sold"
        numberStart.text = "\(shoes.rating)"
        nameProduct.text = shoes.name
        if let url = URL(string: shoes.thumbnail.url) {
            productImageView.loadImageWithShimmer(url: url)
        }
        if shoes.rating == 0 {
            startProduct.image = UIImage(systemName: "star")
        } else if shoes.rating == 5 {
            startProduct.image = UIImage(systemName: "star.fill")
        } else {
            startProduct.image = UIImage(systemName: "star.leadinghalf.filled")
        }
        priceLabel.text = "$\(shoes.minPrice)"
    }
}
