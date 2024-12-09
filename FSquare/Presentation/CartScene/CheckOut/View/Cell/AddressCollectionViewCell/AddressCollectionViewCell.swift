//
//  AddressCollectionViewCell.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 24/11/2024.
//

import UIKit
protocol AddressCollectionViewCellDelegate: AnyObject {
    func didTapEditButton()
}

class AddressCollectionViewCell: UICollectionViewCell {
    var delegate: AddressCollectionViewCellDelegate?
    @IBOutlet var titleLabel: BodyLabel!
    @IBOutlet var addressLabel: DescriptionLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        contentView.layer.cornerRadius = 14
        contentView.layer.masksToBounds = true

        contentView.isSkeletonable = true
        contentView.showAnimatedGradientSkeleton()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Cấu hình shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowRadius = 4

        layer.cornerRadius = 14

        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    }

    private func getAddress(address: AddressData) -> String {
        return "\(address.address), \(address.wardName), \(address.districtName), \(address.provinceName)"
    }

    func setupCell(address: AddressData?) {
        if let address = address, address.id != "0" {
            contentView.hideSkeleton()
            titleLabel.text = address.title
            addressLabel.text = getAddress(address: address)
        } else {
            showAnimatedGradientSkeleton()
        }
    }

    @IBAction func didTapEditButton(_: Any) {
        delegate?.didTapEditButton()
    }
}
