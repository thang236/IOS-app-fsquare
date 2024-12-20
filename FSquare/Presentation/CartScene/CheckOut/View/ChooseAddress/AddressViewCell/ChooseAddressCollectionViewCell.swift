//
//  ChooseAddressCollectionViewCell.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 26/11/2024.
//

import UIKit

class ChooseAddressCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var titleLabel: BodyLabel!
    @IBOutlet private var addressLabel: DescriptionLabel!
    @IBOutlet private var radioIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.backgroundColor = UIColor.white.cgColor
        layer.shadowColor = UIColor.borderDark.cgColor
        layer.shadowOffset = CGSize(width: 2.0, height: 16.0)
        layer.shadowRadius = 12
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false

        layer.cornerRadius = 12
    }

    private func getAddress(address: AddressData) -> String {
        return "\(address.address), \(address.wardName), \(address.districtName), \(address.provinceName)"
    }

    func setupCell(address: AddressData?, isChoose: Bool) {
        guard let address = address else { return }
        titleLabel.text = address.title
        addressLabel.text = getAddress(address: address)

        if isChoose {
            radioIcon.image = UIImage.Toggle.radioSelected
        } else {
            radioIcon.image = UIImage.Toggle.radio
        }
    }
}
