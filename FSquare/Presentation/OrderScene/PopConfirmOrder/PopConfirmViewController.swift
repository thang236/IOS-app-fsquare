//
//  PopConfirmViewController.swift
//  FSquare
//
//  Created by Louis Macbook on 09/12/2024.
//

import UIKit

class PopConfirmViewController: UIViewController {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var backGroundView: UIView!
    private let viewModel : MyOrderViewModel
    private var idOrder: String = ""
    
    init(viewModel : MyOrderViewModel) {
        self.viewModel = viewModel
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
    
    func appear(sender: UIViewController, idOrder: String) {
        self.idOrder = idOrder
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
    
    
    @IBAction func didTapAgree(_ sender: Any) {
        viewModel.patchOrderStatus(idOrder: idOrder, newStatus: "confirmed"){ completion in
            switch completion {
            case .success(_):
                self.hide()
                self.viewModel.getOrderDetail(idOrder: self.idOrder)
            case .failure(let error):
                print(error)
                self.showToast(message: error.localizedDescription, chooseImageToast: .warning)
            }
            
        }
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        hide()
    }
    
}
