import Foundation
import UIKit
import AVFoundation

class StoredVC: UIViewController, UITableViewDataSource, UITableViewDelegate, AVAudioPlayerDelegate {
    
    var recordings = [URL]()
    var audioPlayer: AVAudioPlayer!
    var audioFile:AVAudioFile!
    var tag = 0
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listAllRecordings()
        
        //self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    @IBAction func doneButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recordings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SavedEffectCell
        
        //cell.effectImage = ""
        print(recordings.reversed()[indexPath.row])
        let name = recordings.reversed()[indexPath.row].lastPathComponent
        print("\((name.components(separatedBy: "-"))[0])")
        cell.effectImage.image = UIImage(named: "\((name.components(separatedBy: "-"))[0]).png")
        cell.fileName.text = name
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("CLICK")
        let recording = recordings.reversed()[indexPath.row]
        let name = recordings.reversed()[indexPath.row].lastPathComponent
        let effectName = (name.components(separatedBy: "-"))[0]
        playAudioFile(recording, effectName: effectName)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.deleteRecording(self.recordings.reversed()[indexPath.row])
           // objects.removeAtIndex(indexPath.row)
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
 
    // MARK: -- Functions
    
    func listAllRecordings() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let urls = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
            self.recordings = urls.filter( { (name: URL) -> Bool in
                return name.lastPathComponent.hasSuffix("m4a")
            })
                
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("something went wrong listing recordings")
        }
            
        
    }

    func deleteRecording(_ url:URL) {
        
        print("removing file at \(url.absoluteString)")
        print("removing file at \(url.lastPathComponent)")
        let fileManager = FileManager.default
        
        do {
            try fileManager.removeItem(at: url)
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("error deleting recording")
        }
        
        DispatchQueue.main.async(execute: {
            self.listAllRecordings()
            self.tableView?.reloadData()
        })
    }
    
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

    func playAudioFile(_ filename:URL, effectName:String) {
        audioPlayer?.stop()
        stopAudio()
        let url = filename
        print("playing \(url)")
        print(effectName)
        
        do {
            self.audioFile = try AVAudioFile(forReading: url)
            self.audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            if effectName == "Raw" {
                audioPlayer.volume = 1.0
                audioPlayer.play()
            } else if effectName == "Starwars" {
                PlayEffect.playEffect.playWithEffect(pitch: -1000, rawAudioFile: audioFile)
            } else if effectName == "Fast" {
                PlayEffect.playEffect.playWithEffect(rate: 1.5, rawAudioFile: audioFile)
            } else if effectName == "Animal" {
                PlayEffect.playEffect.playWithEffect(pitch: 1000, rawAudioFile: audioFile)
            } else if effectName == "Time" {
                PlayEffect.playEffect.playWithEffect(reverb: true, rawAudioFile: audioFile)
            } else if effectName == "Slow" {
                PlayEffect.playEffect.playWithEffect(rate: 0.5, rawAudioFile: audioFile)
            } else if effectName == "Echo" {
                PlayEffect.playEffect.playWithEffect(echo: true, rawAudioFile: audioFile)
            }
        } catch let error as NSError {
            self.audioPlayer = nil
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
