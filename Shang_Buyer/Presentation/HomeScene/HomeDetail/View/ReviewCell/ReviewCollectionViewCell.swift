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

class ReviewCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var heightCollectionView: NSLayoutConstraint!
    @IBOutlet weak var contentLabel: DescriptionLabel!
    @IBOutlet weak var timeLabel: DescriptionLabel!
    @IBOutlet weak var avartarImage: UIImageView!
    @IBOutlet weak var starImage5: UIImageView!
    @IBOutlet weak var starImage4: UIImageView!
    @IBOutlet weak var starImage3: UIImageView!
    @IBOutlet weak var starImage2: UIImageView!
    @IBOutlet weak var starImage1: UIImageView!
    @IBOutlet weak var nameLabel: BodyLabel!
    @IBOutlet weak var mediaCollectionView: UICollectionView!
    
    private var reviewData: ReviewData?
    private var mediaItems: [MediaItemGet] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        contentView.isSkeletonable = true
//        contentView.showAnimatedGradientSkeleton()
        self.avartarImage.cornerRadius = 15
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
            if self.reviewData != reviewData {
                self.setupMediaData(reviewData: reviewData)
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
            timeLabel.text = reviewData.createdAt
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withType: MediaGetCollectionViewCell.self, for: indexPath)
        cell.setupCell(with: self.mediaItems[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.bounds.height - 5
        return CGSize(width: size, height: size)
    }
    
    
}
