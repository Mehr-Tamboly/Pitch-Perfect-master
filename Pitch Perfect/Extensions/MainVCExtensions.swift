import Foundation
import UIKit
import AVFoundation

extension MainVC {
    
    func fadeInAndGrowMacCirlce() {
        // Move our fade out code from earlier
        self.timerView.isHidden = false
        self.timerViewToMicContraint.constant = 48
        UIView.animate(withDuration: 0.6, animations: {() -> Void in
            // Animate it to double the size
            let scale: CGFloat = 1.4
            self.micTimerCircle.transform = CGAffineTransform(scaleX: scale, y: scale)
           // self.timerView.frame = CGRectMake(self.timerView.frame.origin.x, (self.timerView.frame.origin.y - 30), self.timerView.frame.size.width, self.timerView.frame.size.height)
            self.view.layoutIfNeeded()
        })
        
    }
    
    func shrinkMicCirlce() {
        // Move our fade out code from earlier
        self.timerView.isHidden = false
        self.timerViewToMicContraint.constant = 16
        UIView.animate(withDuration: 0.6, animations: {() -> Void in
            // Animate it to double the size
            self.micTimerCircle.transform = CGAffineTransform.identity
            self.view.layoutIfNeeded()
            //self.timerView.frame = CGRectMake(self.timerView.frame.origin.x, (self.timerView.frame.origin.y + 30), self.timerView.frame.size.width, self.timerView.frame.size.height)
        })
        
    }
    
    func updateRecordingTimeLabel(_ timer:Timer) {
        
        if audioRecorder.isRecording {
            let min = Int(audioRecorder.currentTime / 60)
            let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
            let s = String(format: "%02d:%02d", min, sec)
            timerLabel.text = s
            audioRecorder.updateMeters()
        }
    }
    
    func effectButtonBoarders(_ tag:Int) {
        if tag == 1 {
            self.effectButton1.layer.borderColor = UIColor.red.cgColor
            self.effectFileName = "Starwars-\(rawFileName)"
        } else if tag == 2 {
            self.effectButton2.layer.borderColor = UIColor.red.cgColor
            self.effectFileName = "Fast-\(rawFileName)"
        } else if tag == 3 {
            self.effectButton3.layer.borderColor = UIColor.red.cgColor
            self.effectFileName = "Animal-\(rawFileName)"
        } else if tag == 4 {
            self.effectButton4.layer.borderColor = UIColor.red.cgColor
            self.effectFileName = "Time-\(rawFileName)"
        } else if tag == 5 {
            self.effectButton5.layer.borderColor = UIColor.red.cgColor
            self.effectFileName = "Slow-\(rawFileName)"
        } else if tag == 6 {
            self.effectButton6.layer.borderColor = UIColor.red.cgColor
            self.effectFileName = "Echo-\(rawFileName)"
        }
        if tag != 1 {
            self.effectButton1.layer.borderColor = buttonBoarderMain
        }
        if tag != 2 {
            self.effectButton2.layer.borderColor = buttonBoarderMain
        }
        if tag != 3 {
            self.effectButton3.layer.borderColor = buttonBoarderMain
        }
        if tag != 4 {
            self.effectButton4.layer.borderColor = buttonBoarderMain
        }
        if tag != 5 {
            self.effectButton5.layer.borderColor = buttonBoarderMain
        }
        if tag != 6 {
            self.effectButton6.layer.borderColor = buttonBoarderMain
        }
    }
    
    func saveEffectAsset(_ asset:AVAsset, fileName:String) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioEffectFileURL = documentsDirectory.appendingPathComponent(fileName)
        
    
        if let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) {
            exporter.outputFileType = AVFileTypeAppleM4A
            exporter.outputURL = audioEffectFileURL
            exporter.audioTimePitchAlgorithm = AVAudioTimePitchAlgorithmVarispeed
            
            let duration = CMTimeGetSeconds(asset.duration)
            if (duration < 0.3) {
                print("sound is not long enough")
                return
            }
            
            exporter.exportAsynchronously(completionHandler: {
                switch exporter.status {
                case  AVAssetExportSessionStatus.failed:
                    print("export failed \(exporter.error)")
                case AVAssetExportSessionStatus.cancelled:
                    print("export cancelled \(exporter.error)")
                default:
                    print("export complete")
                    
                    let filemanager = FileManager.default
                    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
                    let url = URL(fileURLWithPath: path)
                    let filePath = url.appendingPathComponent(self.rawFileName).path
                    if filemanager.fileExists(atPath: filePath) {
                        print("rawFileName sound exists")
                        print(filePath)
                        self.removefirstRecording(URL(fileURLWithPath: filePath))
                        
                    }
                    
                }
            })
        }
        
        
    }
    
    func removefirstRecording(_ url:URL) {
        
        print("removing file at \(url)")
        let fileManager = FileManager.default
        
        do {
            try fileManager.removeItem(at: url)
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("error deleting recording")
        }
    }
}

extension String {
    
    func startsWith(_ string: String) -> Bool {
        
        guard let range = range(of: string, options:[.anchored, .caseInsensitive]) else {
            return false
        }
        
        return range.lowerBound == startIndex
    }
    
}
