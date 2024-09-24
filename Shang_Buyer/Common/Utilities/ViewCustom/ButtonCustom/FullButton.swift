import UIKit

@IBDesignable
class FullButton: BaseButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = UIColor.primaryDark
    }

    override func setup() {
        super.setup()
        backgroundColor = UIColor.primaryDark
        tintColor = .white
    }

    override func updateButtonAppearance() {
        super.updateButtonAppearance()
        if isEnabled {
            backgroundColor = UIColor.primaryDark
            tintColor = .white
        }
    }
}
