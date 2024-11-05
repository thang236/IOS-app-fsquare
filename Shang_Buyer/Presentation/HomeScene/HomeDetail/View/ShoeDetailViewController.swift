//
//  ShoeDetailViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 30/10/2024.
//

import UIKit
import Combine

class ShoeDetailViewController: UIViewController {
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var pageControl: UIPageControl!
    
    private var viewModel: ShoesDetailViewModel?
    private var shoesID: String?
    private var cancellables = Set<AnyCancellable>()
    
    init(shoesID: String, viewModel: ShoesDetailViewModel) {
        self.viewModel = viewModel
        self.shoesID = shoesID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.getShoesDetail(idShoes: shoesID ?? "")
        // Do any additional setup after loading the view.
        setupBindings()
    }
    private func setupBindings() {
        viewModel?.$shoesDetail
            .receive(on: DispatchQueue.main)
            .sink{[weak self] shoesDetail in
                print(shoesDetail)
            }.store(in: &cancellables)
    }
}
