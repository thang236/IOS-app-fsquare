//
//  CartCollectionViewCell.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 21/11/2024.
//

import UIKit

class CartCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var priceLabel: BodyLabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: BodyLabel!
    @IBOutlet private weak var sizeLabel: BodyLabel!
    @IBOutlet private weak var colorLabel: BodyLabel!
    @IBOutlet private weak var colorView: UIView!
    @IBOutlet weak var stepperView: StepperView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        colorView.layer.cornerRadius = colorView.frame.width/2
        colorView.layer.masksToBounds = true
        
        priceLabel.isSkeletonable = true
        imageView.isSkeletonable = true
        nameLabel.isSkeletonable = true
        sizeLabel.isSkeletonable = true
        colorLabel.isSkeletonable = true
        colorView.isSkeletonable = true
        
        contentView.showAnimatedSkeleton()

    }
    
    func setupCell(bag: BagData) {
        priceLabel.text = "\(bag.price)"
        nameLabel.text = bag.shoes
        sizeLabel.text = bag.size
        colorLabel.text = bag.color
        if let url = URL(string: bag.thumbnail.url) {
            imageView.loadImageWithShimmer(url: url)
        }
    }

}
