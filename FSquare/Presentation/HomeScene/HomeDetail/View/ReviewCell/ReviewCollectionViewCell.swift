//
//  ReviewCollectionViewCell.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 05/12/2024.
//

import UIKit

enum MediaItemGet {
    case image(URL)
    case video(URL)
}

protocol ReviewCollectionViewCellDelegate {
    func didTapMediaItem(mediaItem: MediaItemGet)
}

class ReviewCollectionViewCell: UICollectionViewCell {
    var delegate: ReviewCollectionViewCellDelegate?
    @IBOutlet var heightCollectionView: NSLayoutConstraint!
    @IBOutlet var contentLabel: DescriptionLabel!
    @IBOutlet var timeLabel: DescriptionLabel!
    @IBOutlet var avartarImage: UIImageView!
    @IBOutlet var starImage5: UIImageView!
    @IBOutlet var starImage4: UIImageView!
    @IBOutlet var starImage3: UIImageView!
    @IBOutlet var starImage2: UIImageView!
    @IBOutlet var starImage1: UIImageView!
    @IBOutlet var nameLabel: BodyLabel!
    @IBOutlet var mediaCollectionView: UICollectionView!

    private var reviewData: ReviewData?
    private var mediaItems: [MediaItemGet] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.isSkeletonable = true
        showAnimatedGradientSkeleton()
        avartarImage.cornerRadius = 15
        setupCollectionView()
    }

    private func setupCollectionView() {
        mediaCollectionView.registerCell(cellType: MediaGetCollectionViewCell.self)
        mediaCollectionView.delegate = self
        mediaCollectionView.dataSource = self
    }

    private func setupMediaData(reviewData: ReviewData) {
        if let reviewImages = reviewData.images {
            for image in reviewImages {
                if let url = URL(string: image.url) {
                    mediaItems.append(.image(url))
                    mediaCollectionView.reloadData()
                }
            }
        }
        if let reviewVideos = reviewData.videos {
            for video in reviewVideos {
                if let url = URL(string: video.url) {
                    mediaItems.append(.video(url))
                    mediaCollectionView.reloadData()
                }
            }
        }
    }

    private func setUpRating(ratingNumber: Double) {
        let starImages = [starImage1, starImage2, starImage3, starImage4, starImage5]

        let fullStars = Int(ratingNumber)
        let halfStar = (ratingNumber - Double(fullStars)) >= 0.5 ? 1 : 0

        for (index, starImage) in starImages.enumerated() {
            starImage?.image = UIImage(systemName: "star")
            if index < fullStars {
                starImage?.image = UIImage(systemName: "star.fill")
            } else if index == fullStars && halfStar == 1 {
                starImage?.image = UIImage(systemName: "star.leadinghalf.fill")
            }
        }
        for starImage in starImages {
            starImage?.hideSkeleton()
        }
    }

    func setupCell(reviewData: ReviewData?) {
        if let reviewData = reviewData {
            hideSkeleton()
            if self.reviewData != reviewData {
                setupMediaData(reviewData: reviewData)
            } else {
                self.reviewData = reviewData
            }
            hideSkeleton()
            self.reviewData = reviewData
            if let urlAvatar = reviewData.customer.avatar?.url, let url = URL(string: urlAvatar) {
                avartarImage.loadImageWithShimmer(url: url)
            }
            nameLabel.text = "\(reviewData.customer.firstName) \(reviewData.customer.lastName)"
            contentLabel.text = reviewData.content
            timeLabel.text = reviewData.createdAt?.toShortDateTime()
            setUpRating(ratingNumber: reviewData.rating)
            if mediaItems.isEmpty {
                heightCollectionView.constant = 0
            } else {
                heightCollectionView.constant = 80
            }

        } else {
            showAnimatedGradientSkeleton()
        }
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

extension ReviewCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return mediaItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withType: MediaGetCollectionViewCell.self, for: indexPath)
        cell.setupCell(with: mediaItems[indexPath.row])
        return cell
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didTapMediaItem(mediaItem: mediaItems[indexPath.row])
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let size = collectionView.bounds.height - 5
        return CGSize(width: size, height: size)
    }
}
