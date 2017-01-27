import UIKit
import AVFoundation

class MainVC: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    // MARK: -- IBOutlets
    
    @IBOutlet weak var effectButton1: CircleEffectButtons!
    @IBOutlet weak var effectButton2: CircleEffectButtons!
    @IBOutlet weak var effectButton3: CircleEffectButtons!
    @IBOutlet weak var effectButton4: CircleEffectButtons!
    @IBOutlet weak var effectButton5: CircleEffectButtons!
    @IBOutlet weak var effectButton6: CircleEffectButtons!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerCircle: MicCircleView!
    @IBOutlet weak var timerView: TimerView!
    @IBOutlet weak var micButton: UIButton!
    
    @IBOutlet weak var micCircleHeightCon: NSLayoutConstraint!
    @IBOutlet weak var micTimerCircle: MicCircleView!
    @IBOutlet weak var timerViewToMicContraint: NSLayoutConstraint!
    
    // MARK: -- Variables
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var micIsTouched:Bool = false
    var TimerLabelCount:String = "00:00"
    var fileNameURL:URL!
    var audioFile:AVAudioFile!
    var recordingTimer:Timer!
    var rawFileName: String!
    var effectFileName:String = ""
    var effectUsed:Bool = false
    var storeIsEditing:Bool = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        hideEffectButtons()
        hideTimer()
        recordingSession = AVAudioSession.sharedInstance()
        try! recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
        effectButton1.tag = 1
        effectButton2.tag = 2
        effectButton3.tag = 3
        effectButton4.tag = 4
        effectButton5.tag = 5
        effectButton6.tag = 6
        
        
    }
    
    // MARK: -- Fuctions
    
    func setSessionPlayback() {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
        } catch let error as NSError {
            print("could not set session category")
            print(error.localizedDescription)
        }
        do {
            try session.setActive(true)
        } catch let error as NSError {
            print("could not make session active")
            print(error.localizedDescription)
        }
    }
    
    func setSessionPlayAndRecord() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print("could not set session category")
            print(error.localizedDescription)
        }
        do {
            try session.setActive(true)
        } catch let error as NSError {
            print("could not make session active")
            print(error.localizedDescription)
        }
    }
    
    func checkForHeadphones() {
        // check NewDeviceAvailable and OldDeviceUnavailable for them being plugged in/unplugged
        let currentsoundRoute = AVAudioSession.sharedInstance().currentRoute
        if currentsoundRoute.outputs.count > 0 {
            for description in currentsoundRoute.outputs {
                if description.portType == AVAudioSessionPortHeadphones {
                    print("headphones are plugged in")
                    break
                } else {
                    print("headphones are unplugged")
                }
            }
        } else {
            print("you are using a simulator --> headphone check not valid")
        }
    }
    
    // MARK: -- IBActions
    
    @IBAction func savedButtonPressed(_ sender: AnyObject) {
        print("HELLO")
        audioPlayer?.stop()
        print(effectFileName)
        stopAudio()
        if (audioPlayerNode != nil) || (audioPlayer != nil) {
            let alert = UIAlertController(title: "Recorder", message: "Finished Recording", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: {action in
                print("Save was tapped")
                let effectAsset = AVAsset(url:self.fileNameURL!)
                print(effectAsset)
                if self.effectUsed == false {
                    self.effectFileName = "Raw-\(self.rawFileName)"
                }
                self.saveEffectAsset(effectAsset, fileName: self.effectFileName)
                self.audioPlayer = nil
                self.audioPlayerNode = nil
            }))
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: {action in
                print("delete was tapped")
                self.audioRecorder.deleteRecording()
                self.audioPlayer = nil
                self.audioPlayerNode = nil
                self.hideTimer()
                self.hideEffectButtons()
                self.performSegue(withIdentifier: "SavedEffectsSegue", sender: nil)
            }))
            self.present(alert, animated:true, completion:nil)
        }
        print("SAVED")
        performSegue(withIdentifier: "SavedEffectsSegue", sender: nil)
    }
    
    @IBAction func shareButtonPressed(_ sender: AnyObject) {
        self.animateHideEffectButtons()
        displayShareSheet(effectFileName)
    }
    
    @IBAction func infoButtonPressed(_ sender: AnyObject) {
        //performSegueWithIdentifier("settingSegue", sender: nil)
        let alertController = UIAlertController(title: "More Information", message:
            "Thanks for using Pitch Perfect! This app was developed for the IOS developer Udacity course by Mehr Tamboly - Learn more below", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        alertController.addAction(UIAlertAction(title: "Udacity", style: UIAlertActionStyle.default,handler: {
            (action:UIAlertAction!) -> Void in
            UIApplication.shared.openURL(URL(string: "https://www.udacity.com/course/ios-developer-nanodegree--nd003")!)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func micButtonHold(_ sender: AnyObject) {
        effectUsed = false
        audioPlayer?.stop()
        stopAudio()
        effectButtonBoarders(0)
        fadeInAndGrowMacCirlce()
        if audioRecorder == nil {
            startAudioRecorderWithPermissions(true)
            return
        } else {
            startAudioRecorderWithPermissions(false)
        }
    }
    
    @IBAction func micButtonPressed(_ sender: AnyObject) {
        audioRecorder?.stop()
        
        let session = AVAudioSession.sharedInstance()
        do {
            self.animateDisplayEffectButtons()
            self.shrinkMicCirlce()
            try session.setActive(false)
            self.setSessionPlayback()
            self.playAudioFile(0)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func effectButtonPressed(_ buttonTag: UITapGestureRecognizer) {
        effectUsed = true
        let tag = (buttonTag.view?.tag)!
        effectButtonBoarders(tag)
        playAudioFile(tag)
    }
    
    func displayShareSheet(_ name:String) {
        var shareContent:String!
        
        let trueName = name.components(separatedBy: "-")[0]
        if trueName != ""{
            shareContent = "I just made a \(trueName) clip using Pitch Perfect - You can too just go to: "
        } else {
            shareContent = "I just started using Pitch Perfect you can download it from the app store by clicking here: "
        }
        let activityViewController = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
        present(activityViewController, animated: true, completion: {})
    }
    
    

}

