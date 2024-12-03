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

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()

        let size = contentView.systemLayoutSizeFitting(
            CGSize(width: layoutAttributes.frame.width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        layoutAttributes.frame.size = size
        return layoutAttributes
    }
}
