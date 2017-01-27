import Foundation
import UIKit

class MicCircleView: UIView {
    
    override func awakeFromNib() {
        
        layer.borderWidth = 1
        layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 0.7).cgColor
        layer.cornerRadius = frame.size.width/2
        
        
    }
}
