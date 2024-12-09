//
//  HistoryCollectionViewCell.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 05/12/2024.
//

import UIKit

class HistoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet var keyWord: BodyLabel!
    var deleteAction: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupCell(historyData: HistoryData) {
        keyWord.text = historyData.keyword
    }

    @IBAction func didTapDelete(_: Any) {
        deleteAction?()
    }
}
