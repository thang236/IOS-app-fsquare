//
//  TotalCollectionViewCell.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 24/11/2024.
//

import UIKit

class TotalCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var totalLabel: BodyLabel!
    @IBOutlet private var shippingLabel: BodyLabel!
    @IBOutlet private var amountLabel: BodyLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    private func getAmount(amount: Double?) -> String {
        if let amount = amount {
            let amountString = NumberFormatter.formatToVNDWithCustomSymbol(amount)
            return amountString
        } else {
            return "-"
        }
    }
    
    private func getShipping(shipping: Double?) -> String {
        if let shipping = shipping {
            let shippingString = NumberFormatter.formatToVNDWithCustomSymbol(shipping)
            return shippingString
        } else {
            return "-"
        }
    }
    
    func setupCell(amount: Double?, shipping: Double?) {
        shippingLabel.text = getShipping(shipping: shipping)
        amountLabel.text = getAmount(amount: amount)
        if let amount = amount, let shipping = shipping {
            let total = amount + shipping
            totalLabel.text = NumberFormatter.formatToVNDWithCustomSymbol(total)
        } else {
            totalLabel.text = "-"
        }
    }
}
