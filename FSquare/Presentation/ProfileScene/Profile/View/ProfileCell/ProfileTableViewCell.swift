//
//  ProfileTableViewCell.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 04/10/2024.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: BodyLabel!
    @IBOutlet var iconImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUpTableView(profile: Profile) {
        iconImage.image = profile.icon
        titleLabel.text = profile.title
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
