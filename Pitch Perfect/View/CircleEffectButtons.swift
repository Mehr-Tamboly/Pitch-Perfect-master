import Foundation
import UIKit

class CircleEffectButtons: UIImageView {
    
    override func awakeFromNib() {
        layer.cornerRadius = frame.size.width/2
        layer.masksToBounds = true
        layer.borderWidth = 3
        layer.borderColor = buttonBoarderMain
        
    }
}
