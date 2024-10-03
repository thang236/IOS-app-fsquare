//
//  OTPTextField.swift
//  Shang
//
//  Created by Louis Macbook on 11/09/2024.
//

import UIKit

@IBDesignable
class OTPTextField: UITextField {
    private var isConfigured = false
    private var digitLabels = [UILabel]()
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(becomeFirstResponder))
        return recognizer
    }()

    func configure(with slotCount: Int = 4) {
        guard isConfigured == false else { return }
        isConfigured.toggle()
        configureTextField()

        let labelsStackView = createLabelsStackView(with: slotCount)
        addSubview(labelsStackView)
        addGestureRecognizer(tapRecognizer)
        NSLayoutConstraint.activate([
            labelsStackView.topAnchor.constraint(equalTo: topAnchor),
            labelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            labelsStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }

    private func configureTextField() {
        tintColor = .clear
        textColor = .clear
        keyboardType = .numberPad
        textContentType = .oneTimeCode
    }

    private func createLabelsStackView(with count: Int) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 25
        stackView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.borderWidth = 0
        
        
        for _ in 1 ... count {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.layer.borderWidth = 1
            label.layer.cornerRadius = 8
            label.backgroundColor = .clear
            label.layer.borderColor = UIColor.black.cgColor
            label.clipsToBounds = true

            stackView.addArrangedSubview(label)

            digitLabels.append(label)
        }

        return stackView
    }

    @objc
    private func textDidChange() {
        guard let text = text, text.count <= digitLabels.count else {
            self.text = String(text?.prefix(digitLabels.count) ?? "")
            return
        }

        for i in 0 ..< digitLabels.count {
            let currentLabel = digitLabels[i]

            if i < text.count {
                let index = text.index(text.startIndex, offsetBy: i)
                currentLabel.text = String(text[index])
            } else {
                currentLabel.text?.removeAll()
            }
        }

        if text.count == digitLabels.count {
            print("OTP Code: \(text)")
        }
    }
}
