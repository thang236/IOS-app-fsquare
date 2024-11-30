//
//  String+Extension.swift
//  Shang
//
//  Created by Louis Macbook on 01/09/2024.
//

import Foundation
import UIKit

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: font],
                                            context: nil)
        return boundingBox.height
    }
    
    func toShortDate() -> String? {
        let isoFormatter = DateFormatter()
        isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        isoFormatter.locale = Locale(identifier: "en_US_POSIX")

        if let date = isoFormatter.date(from: self) {
            let shortDateFormatter = DateFormatter()
            shortDateFormatter.dateFormat = "yyyy-MM-dd"
            return shortDateFormatter.string(from: date)
        }

        return nil
    }

    func isValidEmail() -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }

    func isValidVietnamesePhoneNumber() -> Bool {
        let regex = "^(0[3|5|7|8|9])[0-9]{8}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }

    func dateComponentsSeparated() -> (year: String?, month: String?, day: String?) {
        let components = self.components(separatedBy: "-")
        if components.count == 3 {
            return (year: components[0], month: components[1], day: components[2])
        } else {
            return (year: nil, month: nil, day: nil)
        }
    }

    func formattedDate() -> String? {
        let components = self.components(separatedBy: "-")
        if components.count >= 3 {
            return "\(components[0])-\(components[1])-\(components[2])"
        }
        return nil
    }

    func toDate(format: String = "yyyy-MM-dd") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }

    func toTime(format: String = "HH:mm") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
}
