//
//  DescriptionCollectionViewCell.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 09/11/2024.
//

import UIKit

class DescriptionCollectionViewCell: UICollectionViewCell {
    @IBOutlet var descriptionLbl: DescriptionLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        DispatchQueue.main.async {
            self.addTopBorder(color: UIColor(hex: "#DADADA"), thickness: 3)
            self.addBottomBorder(color: UIColor(hex: "#DADADA"), thickness: 3)
        }
    }

    func configureCell(description: String) {
        descriptionLbl.text = description
    }
}
