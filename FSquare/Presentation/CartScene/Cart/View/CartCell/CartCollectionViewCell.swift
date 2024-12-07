//
//  CartCollectionViewCell.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 21/11/2024.
//

import UIKit

protocol CartCollectionViewCellDelegate: AnyObject {
    func deleteItem(bag: BagData)
    func increaseQuantity(bag: BagData)
    func decreaseQuantity(bag: BagData)
}

class CartCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var priceLabel: BodyLabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var nameLabel: BodyLabel!
    @IBOutlet private var sizeLabel: BodyLabel!
    @IBOutlet private var colorLabel: BodyLabel!
    @IBOutlet private var colorView: UIView!
    @IBOutlet private var deleteButton: UIButton!

    @IBOutlet var quantityLabel: UILabel!

    private var bag: BagData?
    weak var delegate: CartCollectionViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        colorView.layer.cornerRadius = colorView.frame.width / 2
        colorView.layer.masksToBounds = true

        deleteButton.layer.cornerRadius = deleteButton.frame.width / 2
        deleteButton.layer.masksToBounds = true

        priceLabel.isSkeletonable = true
        imageView.isSkeletonable = true
        nameLabel.isSkeletonable = true
        sizeLabel.isSkeletonable = true
        colorLabel.isSkeletonable = true
        colorView.isSkeletonable = true
        contentView.isSkeletonable = true

        contentView.showAnimatedSkeleton()
    }

    func setupCell(bag: BagData?) {
        if let bag = bag {
            self.bag = bag
            hideSkeleton()

            priceLabel.text = NumberFormatter.formatToVNDWithCustomSymbol(bag.price * Double(bag.quantity))
            nameLabel.text = bag.shoes?.name
            sizeLabel.text = bag.size?.sizeNumber
            colorLabel.text = bag.color
            if let urlString = bag.thumbnail?.url, let url = URL(string: urlString) {
                imageView.loadImageWithShimmer(url: url)
            }
            quantityLabel.text = "\(bag.quantity)"
        } else {
            showAnimatedGradientSkeleton()
        }
    }

    @IBAction func didTapDecrease(_: Any) {
        if let bag = bag {
            delegate?.decreaseQuantity(bag: bag)
        }
    }

    @IBAction func didTapDelete(_: Any) {
        if let bag = bag {
            delegate?.deleteItem(bag: bag)
        }
    }

    @IBAction func didTapIncrease(_: Any) {
        if let bag = bag {
            delegate?.increaseQuantity(bag: bag)
        }
    }
}
