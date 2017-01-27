import Foundation
import UIKit

extension MainVC {
    
    func displayEffectButtons() {
        self.effectButton1.alpha = 1.0
        self.effectButton2.alpha = 1.0
        self.effectButton3.alpha = 1.0
        self.effectButton4.alpha = 1.0
        self.effectButton5.alpha = 1.0
        self.effectButton6.alpha = 1.0
    }
    
    func animateDisplayEffectButtons() {
        self.effectButton1.fadeIn()
        self.effectButton2.fadeIn()
        self.effectButton3.fadeIn()
        self.effectButton4.fadeIn()
        self.effectButton5.fadeIn()
        self.effectButton6.fadeIn()
        
    }
    
    func animateHideEffectButtons() {
        self.effectButton1.fadeOut()
        self.effectButton2.fadeOut()
        self.effectButton3.fadeOut()
        self.effectButton4.fadeOut()
        self.effectButton5.fadeOut()
        self.effectButton6.fadeOut()
        
    }
    
    func hideEffectButtons() {
        self.effectButton1.alpha = 0.0
        self.effectButton2.alpha = 0.0
        self.effectButton3.alpha = 0.0
        self.effectButton4.alpha = 0.0
        self.effectButton5.alpha = 0.0
        self.effectButton6.alpha = 0.0
    }
    
    func hideTimer() {
        self.timerView.isHidden = true
    }
    
    func showTimer() {
        self.timerView.isHidden = false
    }
    
    func animateMicRecording() {
        
    }
    
}
