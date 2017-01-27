import Foundation
import UIKit

extension UIView {
    func fadeIn() {
        // Move our fade out code from earlier
        self.isHidden = false
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
            }, completion: nil)
    }
    
    func fadeOut() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
            }, completion: { void in
                
                self.alpha = 0.0
                
        })
    }
}
