//
//  AddToCartViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 10/11/2024.
//

import UIKit

class AddToCartViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func didTapCloseButton(_: Any) {
        navigationController?.popViewController(animated: true)
    }
}
