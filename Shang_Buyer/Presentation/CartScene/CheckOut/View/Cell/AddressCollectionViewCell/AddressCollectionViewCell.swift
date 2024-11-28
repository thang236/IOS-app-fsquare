//
//  AddressCollectionViewCell.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 24/11/2024.
//

import UIKit

class AddressCollectionViewCell: UICollectionViewCell {
    @IBOutlet var titleLabel: BodyLabel!
    @IBOutlet var addressLabel: DescriptionLabel!
    
    var didTapEditButton: (() -> Void)?
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
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.layer.shadowRadius = 4

        self.layer.cornerRadius = 14

        self.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: self.layer.cornerRadius).cgPath
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
        didTapEditButton?()
    }
}
