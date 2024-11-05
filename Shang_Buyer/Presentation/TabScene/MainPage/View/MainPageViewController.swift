//
//  MainPageViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 28/09/2024.
//

import UIKit

class MainPageViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let token = TokenManager.shared.getAccessToken() else {
            return
        }
    }
}
