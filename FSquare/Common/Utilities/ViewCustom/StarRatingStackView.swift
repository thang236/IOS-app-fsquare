//
//  StarRatingStackView.swift
//
//  Created by Guido on 7/1/20.
//  Copyright © applified.life - All rights reserved.
//

import UIKit

class StarRatingStackView: UIStackView {
    @IBOutlet var star1ImageView: UIImageView!
    @IBOutlet var star2ImageView: UIImageView!
    @IBOutlet var star3ImageView: UIImageView!
    @IBOutlet var star4ImageView: UIImageView!
    @IBOutlet var star5ImageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
