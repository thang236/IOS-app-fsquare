//
//  MediaRattingCollectionViewCell.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 04/12/2024.
//

import AVFoundation
import AVKit
import UIKit

class MediaRattingCollectionViewCell: UICollectionViewCell {
    @IBOutlet var videoView: UIView!
    @IBOutlet var imageView: UIImageView!
    private var player: AVPlayer!
    var avpController = AVPlayerViewController()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCell(mediaItem: MediaItem) {
        switch mediaItem {
        case let .image(image):
            imageView.isHidden = false
            imageView.image = image
        case let .video(url):
            imageView.isHidden = true
            videoView.isHidden = false
            displayVideo(from: url)
        }
    }

    private func displayVideo(from url: URL) {
        videoView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }

        player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = videoView.bounds
        playerLayer.videoGravity = .resizeAspectFill
        videoView.layer.addSublayer(playerLayer)

        player.play()
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()

        let size = contentView.systemLayoutSizeFitting(
            CGSize(width: layoutAttributes.frame.width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        layoutAttributes.frame.size = size
        return layoutAttributes
    }
}
