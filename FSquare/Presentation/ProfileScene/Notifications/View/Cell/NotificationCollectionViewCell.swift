//
//  NotificationCollectionViewCell.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 05/12/2024.
//

import UIKit

class NotificationCollectionViewCell: UICollectionViewCell {
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var titleLabel: BodyLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.cornerRadius = 16
        contentView.layer.masksToBounds = true
    }

    func setupCell(notiData: NotificationData) {
        titleLabel.text = notiData.title
        contentLabel.text = notiData.content
    }
}
