import UIKit

@IBDesignable
class FullButton: BaseButton {
  
    override func setup() {
        super.setup()
        self.backgroundColor = UIColor.primaryDark
        
    }
    
    override func updateButtonAppearance() {
        super.updateButtonAppearance()
        if self.isEnabled {
            self.backgroundColor = UIColor.primaryDark
            self.tintColor = .white
        }
    }
}
