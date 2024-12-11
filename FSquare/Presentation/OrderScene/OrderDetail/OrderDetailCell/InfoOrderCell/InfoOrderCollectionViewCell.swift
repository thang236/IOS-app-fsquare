//
//  InfoOrderCollectionViewCell.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 03/12/2024.
//

import UIKit

class InfoOrderCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var titleAddress: BodyLabel!
    @IBOutlet private var addressValue: BodyLabel!
    @IBOutlet private var statusTitleLabel: BodyLabel!
    @IBOutlet private var timeLabel: BodyLabel!
    @IBOutlet private var orderIDLabel: BodyLabel!
    @IBOutlet private var statusValue: BodyLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        contentView.isSkeletonable = true
        contentView.showAnimatedGradientSkeleton()
    }

    private func getShippingAddress(address: ShippingAddress) -> String {
        return "\(address.toName) (\(address.toPhone))"
    }

    private func getValueAddress(address: ShippingAddress) -> String {
        return "\(address.toAddress), \(address.toWardName), \(address.toDistrictName), \(address.toProvinceName)"
    }

    private func getStatusTitle(orderData: OrderData) {
        switch orderData.status {
        case "pending":
            statusTitleLabel.text = "Đơn hàng đang được xử lý"
            statusValue.text = "Đang xử lý"
        case "processing":
            statusTitleLabel.text = "Đơn hàng đang được chuẩn bị"
            statusValue.text = "Đang chuẩn bị"
        case "shipped":
            statusTitleLabel.text = "Đơn hàng đã được giao cho đơn vị vận chuyển"
            statusValue.text = "Đang tới đơn vị vận chuyển"
        case "delivered":
            statusTitleLabel.text = "Đơn hàng đang được giao tới bạn"
            statusValue.text = "Đang giao"
        case "confirmed":
            statusTitleLabel.text = "Đơn hàng đã được giao tới bạn"
            statusValue.text = "Đã giao"
        case "cancelled":
            statusTitleLabel.text = "Đơn hàng đã bị hủy"
            statusValue.text = "Đã hủy"
        case "returned":
            if let returnInfo = orderData.returnInfo {
                switch returnInfo.status {
                case "pending":
                    statusTitleLabel.text = "Đơn hàng đang được xử lý hoàn trả"
                    statusValue.text = "Đang xử lý hoàn trả"
                case "initiated":
                    statusTitleLabel.text = "Đã chấp nhận - Đang chờ kiểm hàng"
                    statusValue.text = "Đang xử lý hoàn trả"
                case "completed":
                    statusTitleLabel.text = "Đã kiểm hàng chờ hoàn tiền"
                    statusValue.text = "Đã chấp thuận hoàn trả"
                case "refunded":
                    statusTitleLabel.text = "Đã hoàn tiền"
                    statusValue.text = "Hoàn hàng thành công"
                case "cancelled":
                    statusTitleLabel.text = "Từ chối hoàn hàng"
                    statusValue.text = "Từ chới hoàn hàng"
                default:
                    statusTitleLabel.text = "Trạng thái đơn hàng không xác định"
                    statusValue.text = "Đã có lỗi xảy ra"
                }
            }
        default:
            statusTitleLabel.text = "Trạng thái đơn hàng không xác định"
            statusValue.text = "Đã có lỗi xảy ra"
        }
    }

    private func getTimeOrder(orderData: OrderData) -> String {
        guard let statusTimestamps = orderData.statusTimestamps else { return "" }
        switch orderData.status {
        case "pending":
            return statusTimestamps.pending?.toShortDate() ?? ""
        case "processing":
            return statusTimestamps.processing?.toShortDate() ?? ""
        case "shipped":
            return statusTimestamps.shipped?.toShortDate() ?? ""
        case "delivered":
            return statusTimestamps.delivered?.toShortDate() ?? ""
        case "confirmed":
            return statusTimestamps.confirmed?.toShortDate() ?? ""
        case "cancelled":
            return statusTimestamps.cancelled?.toShortDate() ?? ""
        case "returned":
            if let returnInfo = orderData.returnInfo {
                switch returnInfo.status {
                case "pending":
                    return returnInfo.statusTimestamps?.pending?.toShortDate() ?? ""
                case "initiated":
                    return returnInfo.statusTimestamps?.initiated?.toShortDate() ?? ""
                case "completed":
                    return returnInfo.statusTimestamps?.completed?.toShortDate() ?? ""
                case "refunded":
                    return returnInfo.statusTimestamps?.refunded?.toShortDate() ?? ""
                case "cancelled":
                    return returnInfo.statusTimestamps?.cancelled?.toShortDate() ?? ""
                default:
                    return "Đã có lỗi xảy ra"
                }
            } else {
                return "Đã có lỗi xảy ra"
            }
        default:
            return "Đã có lỗi xảy ra"
        }
    }

    func setupCell(orderData: OrderData?) {
        if let orderData = orderData {
            contentView.hideSkeleton()
            orderIDLabel.text = orderData.clientOrderCode

            getStatusTitle(orderData: orderData)
            timeLabel.text = getTimeOrder(orderData: orderData)

            if let shippingAddress = orderData.shippingAddress {
                titleAddress.text = getShippingAddress(address: shippingAddress)
                addressValue.text = getValueAddress(address: shippingAddress)
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
