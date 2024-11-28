//
//  PaymentCollectionViewCell.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 26/11/2024.
//

import UIKit

class PaymentCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var paymentView2: UIView!
    @IBOutlet private weak var paymentView1: UIView!
    
    @IBOutlet private weak var checkIcon2: UIImageView!
    @IBOutlet private weak var checkIcon1: UIImageView!
    
    var didTapPaymentView1: (() -> Void)?
    var didTapPaymentView2: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupGestureRecognizers()
    }
    
    private func setupGestureRecognizers() {
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(paymentView1Tapped))
        paymentView1.isUserInteractionEnabled = true
        paymentView1.addGestureRecognizer(tapGesture1)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(paymentView2Tapped))
        paymentView2.isUserInteractionEnabled = true
        paymentView2.addGestureRecognizer(tapGesture2)
    }
    
    @objc private func paymentView1Tapped() {
        checkIcon1.isHidden = false
        checkIcon2.isHidden = true
        didTapPaymentView1?()
    }
    
    @objc private func paymentView2Tapped() {
        checkIcon2.isHidden = false
        checkIcon1.isHidden = true
        didTapPaymentView2?()
    }

}
