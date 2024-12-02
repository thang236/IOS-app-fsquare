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

            self.contentView.isSkeletonable = true
            self.contentView.showAnimatedGradientSkeleton()
        }
    }

    func configureCell(description: String) {
        if description != "nil" {
            hideSkeleton()
            descriptionLbl.text = description
        } else {
            showAnimatedGradientSkeleton()
        }
    }

    func calculateHeightOfCell(description: String, width: CGFloat) -> CGFloat {
        descriptionLbl.text = description
        let targetSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let calculatedSize = descriptionLbl.sizeThatFits(targetSize)
        return calculatedSize.height
    }
}
