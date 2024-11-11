//
//  AddressTableViewCell.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 10/11/2024.
//

import UIKit

protocol AddressTableViewCellDelegate {
    func didTapEditButton(address: AddressData)
}

class AddressTableViewCell: UITableViewCell {
    @IBOutlet var isDefaultView: UIView!
    @IBOutlet var titleLbl: BodyLabel!
    var delegate: AddressTableViewCellDelegate?
    private var address: AddressData? = nil

    @IBOutlet var addressLbl: DescriptionLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    private func getFullAddress(address: AddressData) -> String {
        return "\(address.address), \(address.wardName), \(address.districtName), \(address.provinceName)"
    }

    func setupCell(address: AddressData) {
        self.address = address
        titleLbl.text = address.title
        addressLbl.text = getFullAddress(address: address)
        isDefaultView.isHidden = !address.isDefault
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func tapEditButton(_: Any) {
        guard let address = address else { return }
        delegate?.didTapEditButton(address: address)
    }
}
