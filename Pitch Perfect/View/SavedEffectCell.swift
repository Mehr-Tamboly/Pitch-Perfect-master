import Foundation
import UIKit

class SavedEffectCell: UITableViewCell {
    
    // MARK: -- Outlets
    @IBOutlet weak var effectImage: CircleEffectButtons!
    @IBOutlet weak var fileName: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    
    // MARK: -- Variables
    var playerActive:Bool = false
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: -- Actions
    @IBAction func playPauseButtonPressed(_ sender: AnyObject) {
        if playerActive {
            
        } else {
            //self.playPauseButton.imageView?.image = ""
        }
    }
    
    
}
