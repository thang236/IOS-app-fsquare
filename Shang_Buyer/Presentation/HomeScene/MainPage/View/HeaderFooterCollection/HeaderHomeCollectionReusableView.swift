//
//  HeaderHomeCollectionReusableView.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 12/11/2024.
//

import UIKit

protocol HeaderHomeCollectionReusableViewDelegate: AnyObject {
    func didTapSeeMoreButton(homeCollectionType: HomeCollectionType)
}

class HeaderHomeCollectionReusableView: UICollectionReusableView {
    var delegate: HeaderHomeCollectionReusableViewDelegate?
    static let reuseIdentifier = "UICollectionElementKindSectionHeader"
    private var homeCollectionType: HomeCollectionType?

    // MARK: - UI Elements

    private let titleLabel: HeadingLabel = {
        let label = HeadingLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.interItalicVariableFont(fontWeight: .semibold, size: 20)
        label.textColor = .black
        return label
    }()

    private let seeMoreButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("See More", for: .normal)
        button.setTitleColor(.primaryDark, for: .normal)
        button.titleLabel?.font = UIFont.interItalicVariableFont(fontWeight: .medium, size: 16)
        return button
    }()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupActions()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(titleLabel)
        addSubview(seeMoreButton)

        // Layout constraints
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            seeMoreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            seeMoreButton.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    private func setupActions() {
        seeMoreButton.addTarget(self, action: #selector(seeMoreButtonTapped), for: .touchUpInside)
    }

    // MARK: - Configure Header

    func configure(homeCollectionType: HomeCollectionType) {
        titleLabel.text = homeCollectionType.title
        self.homeCollectionType = homeCollectionType
    }

    @objc private func seeMoreButtonTapped() {
        guard let homeCollectionType = homeCollectionType else { return }
        delegate?.didTapSeeMoreButton(homeCollectionType: homeCollectionType)
    }
}
