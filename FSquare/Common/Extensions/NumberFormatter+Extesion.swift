//
//  NumberFormatter+Extesion.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 23/11/2024.
//

import Foundation

extension NumberFormatter {
    static func formatToVNDWithCustomSymbol(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "vi_VN")
        formatter.maximumFractionDigits = 0
        if let formattedString = formatter.string(from: NSNumber(value: amount)) {
            let customFormattedString = formattedString.replacingOccurrences(of: "₫", with: "").trimmingCharacters(in: .whitespaces)
            return "₫\(customFormattedString)"
        }
        return "₫\(amount)"
    }
}
