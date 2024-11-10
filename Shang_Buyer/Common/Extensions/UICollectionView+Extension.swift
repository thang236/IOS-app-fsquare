//
//  UICollectionView+Extension.swift
//  Shang
//
//  Created by Louis Macbook on 01/09/2024.
//

import UIKit

extension UICollectionView {
    func registerCell<T: UICollectionViewCell>(cellType _: T.Type) {
        let identifier = String(describing: T.self)
        let nib = UINib(nibName: identifier, bundle: nil)
        register(nib, forCellWithReuseIdentifier: identifier)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(withType type: T.Type, for indexPath: IndexPath) -> T {
        let identifier = String(describing: type)
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            print("Unable to dequeue \(identifier)")
            return UICollectionViewCell() as! T
        }
        return cell
    }
}
