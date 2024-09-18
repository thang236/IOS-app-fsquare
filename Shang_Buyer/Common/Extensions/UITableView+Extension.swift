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

    func configure<T: UITableViewCell>(cellType: T.Type, at indexPath: IndexPath, with _: Any) -> T {
        let identifier = String(describing: cellType)
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            return UITableViewCell() as! T
        }

//        if let taskCell = cell as? TaskTableViewCell, let data = item as? TaskModel {
//            taskCell.setupTableView(task: data)
//        }

        return cell
    }
}
