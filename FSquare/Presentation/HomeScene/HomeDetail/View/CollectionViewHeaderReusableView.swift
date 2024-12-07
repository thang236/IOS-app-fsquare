//
//  CollectionViewHeaderReusableView.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 04/11/2024.
//

import UIKit

final class CollectionViewHeaderReusableView: UICollectionReusableView {
    @IBOutlet var cellTitleLbl: UILabel!

    func setup(_ title: String) {
        cellTitleLbl.text = title
    }
}
