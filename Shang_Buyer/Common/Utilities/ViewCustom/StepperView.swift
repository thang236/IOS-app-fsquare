//
//  StepperView.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 10/11/2024.
//

import Foundation
import UIKit

protocol StepperViewDelegate: AnyObject {
    func showToast(message: String)
}

@IBDesignable
class StepperView: UIView {
    var delegate: StepperViewDelegate?

    @IBInspectable var labelFontSize: CGFloat = 22 {
        didSet {
            valueLabel.font = .systemFont(ofSize: labelFontSize, weight: .semibold)
        }
    }

    private let decrementButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("-", for: .normal)
        button.setTitleColor(.neutralUltraDark, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .regular)
        button.backgroundColor = .backgroundMedium
        return button
    }()

    private let incrementButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.setTitleColor(.neutralUltraDark, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .regular)
        button.backgroundColor = .backgroundMedium
        return button
    }()

    private let valueLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.font = .interItalicVariableFont(fontWeight: .semibold, size: 22)
        label.textAlignment = .center
        return label
    }()

    private var value: Int = 1 {
        didSet {
            valueLabel.text = "\(value)"
        }
    }

    private var maxValue: Int? = nil

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
        stackView.spacing = 8

        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            decrementButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            decrementButton.widthAnchor.constraint(equalTo: decrementButton.heightAnchor),

            incrementButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            incrementButton.widthAnchor.constraint(equalTo: incrementButton.heightAnchor),
        ])

        decrementButton.addTarget(self, action: #selector(decrementValue), for: .touchUpInside)
        incrementButton.addTarget(self, action: #selector(incrementValue), for: .touchUpInside)
    }

    func getValue() -> Int {
        return value
    }

    func setValue(value: Int) {
        self.value = value
    }

    @objc private func decrementValue() {
        if value > 1 {
            value -= 1
        }
    }

    func setMaxValue(maxValue: Int) {
        self.maxValue = maxValue
    }

    @objc private func incrementValue() {
        guard let maxValue = maxValue else {
            value += 1
            return
        }

        if value >= maxValue {
            if maxValue == 1 {
                delegate?.showToast(message: "hãy chọn size trước khi chọn số lượng")
            } else {
                delegate?.showToast(message: "số lượng mua không thể vượt qua số lượng hiện có")
            }
            return
        }

        value += 1
    }
}
