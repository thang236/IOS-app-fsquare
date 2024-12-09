//
//  SheetLogoutViewController.swift
//  FSquare
//
//  Created by Louis Macbook on 08/12/2024.
//

import UIKit
protocol SheetLogoutViewControllerDelegate: AnyObject {
    func didTapLogoutButton()
}

class SheetLogoutViewController: UIViewController {
    var delegate: SheetLogoutViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func didTapCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func didTapLogoutButton(_ sender: Any) {
        self.dismiss(animated: true){
            self.delegate?.didTapLogoutButton()
        }
        
    }
}
