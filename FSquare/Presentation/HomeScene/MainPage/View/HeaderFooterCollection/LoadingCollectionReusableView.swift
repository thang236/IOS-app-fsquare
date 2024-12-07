//
//  LoadingCollectionReusableView.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 16/11/2024.
//

import UIKit

class LoadingCollectionReusableView: UICollectionReusableView {
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func startAnimating() {
        activityIndicator.startAnimating()
    }

    func stopAnimating() {
        activityIndicator.stopAnimating()
    }
}
