//
//  UITableView+Extension.swift
//  Shang
//
//  Created by Louis Macbook on 01/09/2024.
//

import Foundation
import UIKit

extension UITableView {
    func registerCell<T: UITableViewCell>(cellType: T.Type) {
        let identifier = String(describing: cellType)
        let nib = UINib(nibName: identifier, bundle: nil)
        register(nib, forCellReuseIdentifier: identifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(cellType: T.Type, at indexPath: IndexPath) -> T {
        let identifier = String(describing: cellType)
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            print("Error: Cell with identifier \(identifier) could not be dequeued.")
            return UITableViewCell() as! T
        }
        return cell
    }
}
