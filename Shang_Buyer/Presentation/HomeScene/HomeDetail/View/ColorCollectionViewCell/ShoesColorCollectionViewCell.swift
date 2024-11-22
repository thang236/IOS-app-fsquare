//
//  ShoesColorCollectionViewCell.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 04/11/2024.
//

import UIKit

class ShoesColorCollectionViewCell: UICollectionViewCell {
    @IBOutlet var backgroundLayout: UIView!
    @IBOutlet var colorLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    func setupCell(titleButton: String) {
        colorLabel.text = titleButton
    }

    func setChooseCell() {
        backgroundLayout.backgroundColor = .primaryDark
        colorLabel.textColor = .white
    }

    func setUnChooseCell() {
        backgroundLayout.backgroundColor = .clear
        colorLabel.textColor = .primaryDark
    }
}
