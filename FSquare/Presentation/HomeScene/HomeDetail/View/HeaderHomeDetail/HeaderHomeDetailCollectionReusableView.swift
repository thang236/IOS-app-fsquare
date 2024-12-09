//
//  HeaderHomeDetailCollectionReusableView.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 21/11/2024.
//

import UIKit

class HeaderHomeDetailCollectionReusableView: UICollectionReusableView {
    static let reuseIdentifier = "HeaderHomeDetailCollectionReusableView"

    private let titleLabel: BodyLabel = {
        let label = BodyLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.interItalicVariableFont(fontWeight: .medium, size: 15)
        label.textColor = .black
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    func configure(shoesDetailSectionType: ShoesDetailSectionType) {
        titleLabel.text = shoesDetailSectionType.title
    }
}
