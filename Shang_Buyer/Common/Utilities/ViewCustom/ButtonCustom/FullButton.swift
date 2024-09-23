import UIKit

@IBDesignable
class FullButton: BaseButton {
    override func setup() {
        super.setup()
        backgroundColor = UIColor.primaryDark
    }

    override func updateButtonAppearance() {
        super.updateButtonAppearance()
        if isEnabled {
            backgroundColor = UIColor.primaryDark
            tintColor = .white
        }
    }
}
