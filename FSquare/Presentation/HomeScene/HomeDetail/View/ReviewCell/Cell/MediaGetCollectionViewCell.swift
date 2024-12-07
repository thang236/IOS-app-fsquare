//
//  MediaGetCollectionViewCell.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 05/12/2024.
//

import AVFoundation
import UIKit

class MediaGetCollectionViewCell: UICollectionViewCell {
    @IBOutlet var mediaImageView: UIImageView!
    @IBOutlet var mediaContainerView: UIView!

    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCell(with mediaItem: MediaItemGet) {
        switch mediaItem {
        case let .image(url):
            showImage(from: url)
        case let .video(url):
            showVideo(from: url)
        }
    }

    private func showImage(from url: URL) {
        mediaImageView.loadImageWithShimmer(url: url)
        mediaImageView.contentMode = .scaleAspectFill
    }

    private func showVideo(from url: URL) {
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = mediaContainerView.bounds
        playerLayer?.videoGravity = .resizeAspectFill
        mediaContainerView.layer.addSublayer(playerLayer!)

        player?.pause()
        mediaImageView.backgroundColor = .clear
        mediaImageView.image = UIImage(systemName: "play.fill")
        mediaImageView.tintColor = .black
        mediaImageView.contentMode = .center
        DispatchQueue.main.async {
            self.mediaContainerView.bringSubviewToFront(self.mediaImageView)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        player?.pause()
        playerLayer?.removeFromSuperlayer()
    }
}
