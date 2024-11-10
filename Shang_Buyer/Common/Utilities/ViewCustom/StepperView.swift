//
//  StepperView.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 10/11/2024.
//

import Foundation
import UIKit

@IBDesignable
class StepperView: UIView {
    private let decrementButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("-", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        button.backgroundColor = .backgroundMedium
        return button
    }()

    private let incrementButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        button.backgroundColor = .backgroundMedium
        return button
    }()

    private let valueLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()

    private var value: Int = 1 {
        didSet {
            valueLabel.text = "\(value)"
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        let stackView = UIStackView(arrangedSubviews: [decrementButton, valueLabel, incrementButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing

        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        decrementButton.addTarget(self, action: #selector(decrementValue), for: .touchUpInside)
        incrementButton.addTarget(self, action: #selector(incrementValue), for: .touchUpInside)
    }

    @objc private func decrementValue() {
        if value > 0 {
            value -= 1
        }
    }

    @objc private func incrementValue() {
        value += 1
    }
}
