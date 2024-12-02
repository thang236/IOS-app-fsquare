//
//  StatusOrderCollectionViewCell.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 30/11/2024.
//

import UIKit

class StatusOrderCollectionViewCell: UICollectionViewCell {
    @IBOutlet var bottomView: UIView!
    @IBOutlet var titleStatusLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCell(title: String) {
        titleStatusLabel.text = title
    }

    func chooseCell() {
        bottomView.backgroundColor = .primaryDark
    }

    func unChooseCell() {
        bottomView.backgroundColor = .borderMedium
    }
}
