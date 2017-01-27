import Foundation
import UIKit
import AVFoundation

extension MainVC {
    
    // MARK: -- Play Audio
    
    func playAudioFile(_ tag:Int) {
        audioPlayer?.stop()
        stopAudio()
        var url:URL?
        if self.audioRecorder != nil {
            url = self.audioRecorder.url
        } else {
            url = self.fileNameURL! as URL
        }
        print("playing \(url)")
        
        do {
            self.audioFile = try AVAudioFile(forReading: url!)
            self.audioPlayer = try AVAudioPlayer(contentsOf: url!)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            if tag == 0 {
                audioPlayer.volume = 1.0
                audioPlayer.play()
            } else if tag == 1 {
                PlayEffect.playEffect.playWithEffect(pitch: -1000, rawAudioFile: audioFile)
            } else if tag == 2 {
                PlayEffect.playEffect.playWithEffect(rate: 1.5, rawAudioFile: audioFile)
            } else if tag == 3 {
                PlayEffect.playEffect.playWithEffect(pitch: 1000, rawAudioFile: audioFile)
            } else if tag == 4 {
                PlayEffect.playEffect.playWithEffect(reverb: true, rawAudioFile: audioFile)
            } else if tag == 5 {
                PlayEffect.playEffect.playWithEffect(rate: 0.5, rawAudioFile: audioFile)
            } else if tag == 6 {
                PlayEffect.playEffect.playWithEffect(echo: true, rawAudioFile: audioFile)
            }
        } catch let error as NSError {
            self.audioPlayer = nil
            print(error.localizedDescription)
        }
    }
    
    // Mark: -- Setup Audio Recorder
    
    func startAudioRecorderWithPermissions(_ permissions: Bool) {
        if recordingSession.responds(to: #selector(AVAudioSession.requestRecordPermission(_:))) {
            AVAudioSession.sharedInstance().requestRecordPermission({ (permissionGranted: Bool) in
                if permissionGranted {
                    self.setSessionPlayAndRecord()
                    if permissions {
                        self.setupRecorder()
                    }
                    self.audioRecorder.record()
                    self.recordingTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(MainVC.updateRecordingTimeLabel(_:)), userInfo: nil, repeats: true)
                } else {
                    print("The user has not granted permission to record content")
                }
            })
        } else {
            print("requestRecordPermission unrecognized")
        }
    }
    
    func setupRecorder() {
        let format = DateFormatter()
        format.dateFormat="yyyy-MM-dd-HH-mm-ss"
        rawFileName = "\(format.string(from: Date())).m4a"
        print(rawFileName)
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        self.fileNameURL = documentsDirectory.appendingPathComponent(rawFileName)
        
        if FileManager.default.fileExists(atPath: fileNameURL.absoluteString) {
            // probably won't happen. want to do something about it?
            print("soundfile \(fileNameURL.absoluteString) exists")
        }
        
        let recordSettings:[String : AnyObject] = [
            AVFormatIDKey: NSNumber(value: kAudioFormatAppleLossless as UInt32),
            AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue as AnyObject,
            AVEncoderBitRateKey : 320000 as AnyObject,
            AVNumberOfChannelsKey: 2 as AnyObject,
            AVSampleRateKey : 44100.0 as AnyObject
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileNameURL as URL, settings: recordSettings)
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord() // creates/overwrites the file at soundFileURL
        } catch let error as NSError {
            audioRecorder = nil
            print(error.localizedDescription)
        }
        
    }
    
    func stopAudio() {
        if let audioPlayerNode = audioPlayerNode {
            audioPlayerNode.stop()
        }
        
        if let audioEngine = audioEngine {
            audioEngine.stop()
            audioEngine.reset()
        }
    }
    
}
