//
//  MediaViewController.swift
//  FSquare
//
//  Created by ThangHT on 13/12/2024.
//

import AVFoundation
import AVKit
import UIKit

class MediaViewController: UIViewController {
    @IBOutlet private var backView: UIView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var contentView: UIView!

    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?

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
        backView.backgroundColor = .black.withAlphaComponent(0.6)
        backView.alpha = 0
        contentView.alpha = 0
        contentView.layer.cornerRadius = 10
    }

    func appear(sender: UIViewController, with url: URL) {
        sender.present(self, animated: false) {
            self.show()
            self.showImage(from: url)
        }
    }

    private func showImage(from url: URL) {
        imageView.loadImageWithShimmer(url: url)
        imageView.contentMode = .scaleAspectFill
    }

    private func show() {
        UIView.animate(withDuration: 0.3, delay: 0.1) {
            self.backView.alpha = 1
            self.contentView.alpha = 1
        }
    }

    func hide() {
        UIView.animate(withDuration: 0.3, delay: 0.0) {
            self.backView.alpha = 0
            self.contentView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }

    @IBAction func didTapCloseButton(_: Any) {
        hide()
    }
}
