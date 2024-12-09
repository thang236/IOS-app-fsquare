//
//  PopUpLoginViewController.swift
//  FSquare
//
//  Created by Louis Macbook on 07/12/2024.
//

import UIKit

protocol PopUpLoginViewControllerDelegate: AnyObject {
    func didTapLoginButton()
    func didTapBackButton()
}

class PopUpLoginViewController: UIViewController {
    var delegate: PopUpLoginViewControllerDelegate?
    @IBOutlet weak var LoginButton: FullButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var backButton: LightButton!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    func configView() {
        view.backgroundColor = .clear
        backGroundView.backgroundColor = .black.withAlphaComponent(0.6)
        backGroundView.alpha = 0
        contentView.alpha = 0
        contentView.layer.cornerRadius = 10
    }
    
    func appear(sender: UIViewController) {
        sender.present(self, animated: false) {
            self.show()
        }
    }
    

    private func show() {
        UIView.animate(withDuration: 0.3, delay: 0.1) {
            self.backGroundView.alpha = 1
            self.contentView.alpha = 1
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.3, delay: 0.0) {
            self.backGroundView.alpha = 0
            self.contentView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }


    @IBAction func didTapLoginButton(_ sender: Any) {
        hide()
        delegate?.didTapLoginButton()
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        hide()
        delegate?.didTapBackButton()
    }
}
