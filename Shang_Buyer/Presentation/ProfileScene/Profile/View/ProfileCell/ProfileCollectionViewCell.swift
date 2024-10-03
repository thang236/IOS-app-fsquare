//
//  ProfileCollectionViewCell.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 03/10/2024.
//

import UIKit

protocol ProfileCollectionViewCellDelegate {
    func onClickNavigation()
}

class ProfileCollectionViewCell: UICollectionViewCell {
    var delegate: ProfileCollectionViewCellDelegate?

    @IBOutlet weak var titleLabel: BodyLabel!
    @IBOutlet weak var iconImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    private func setUpTableView(profile: Profile){
        iconImage.image = profile.icon
        titleLabel.text = profile.title
    }

    @IBAction func didTapNavigation(_ sender: Any) {
        delegate?.onClickNavigation()
    }
}
