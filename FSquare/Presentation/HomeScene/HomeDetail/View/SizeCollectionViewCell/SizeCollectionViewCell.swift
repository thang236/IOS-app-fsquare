//
//  SizeCollectionViewCell.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 31/10/2024.
//

import UIKit

class SizeCollectionViewCell: UICollectionViewCell {
    @IBOutlet var background: UIView!
    @IBOutlet var sizeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        background.layer.cornerRadius = 17
        background.layer.masksToBounds = true
    }

    func setupCell(titleButton: String) {
        sizeLabel.text = titleButton
    }

    func setCellChoose() {
        background.backgroundColor = .primaryDark
        sizeLabel.textColor = .white
    }

    func setCellUnChoose() {
        background.backgroundColor = .clear
        sizeLabel.textColor = .primaryDark
    }
}
