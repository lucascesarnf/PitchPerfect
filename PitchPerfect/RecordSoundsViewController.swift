//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Lucas César  Nogueira Fonseca on 20/02/2018.
//  Copyright © 2018 Lucas César  Nogueira Fonseca. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController , AVAudioRecorderDelegate {
    
    enum RecordState: String {
         case recording = "Recording in progress"
         case waiting = "Tap to Record"
        
    }
    
    var audioRecorder: AVAudioRecorder!
    let segueIdentifier = "finishRecordSegue"
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRecordState(recordIsEnable:true)
        UIApplication.shared.statusBarStyle = .lightContent
        
        //Here to can set the division line of the navigation invisible, I set a empty image both on background an shadow
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    // MARK: - Actions
    @IBAction func recordAudio(_ sender: Any) {
        setRecordState(recordIsEnable:false)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        setRecordState(recordIsEnable:true)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    // MARK: - Utils
    func setRecordState(recordIsEnable: Bool) {
         recordButton.isEnabled = recordIsEnable
         stopRecordingButton.isEnabled = !recordIsEnable
        if recordIsEnable {
            stopRecordAnimation()
            recordingLabel.text = RecordState.waiting.rawValue
        } else {
            recordAnimation()
            recordingLabel.text = RecordState.recording.rawValue
        }
    }
    
    // MARK: - AudioRecorder
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: segueIdentifier, sender: audioRecorder.url)
        } else {
             showAlert(Alerts.RecordingFailedTitle, message:Alerts.RecordingFailedMessage)
        }
    }
    
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordAudioURL
        }
    }
    
    // MARK: - Animation
    func recordAnimation() {
        UIView.animate(withDuration: 0.8, delay: 0, options: [.repeat, .autoreverse], animations: {
           self.recordButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.view.layoutIfNeeded()
            self.recordingLabel.alpha = 0.3
        }, completion: nil)
    }
    
    func stopRecordAnimation() {
        UIView.animate(withDuration: 0.5, animations: {
            self.recordingLabel.alpha = 1
            self.recordButton.transform = CGAffineTransform.identity
        }, completion: { _ in
                self.recordingLabel.layer.removeAllAnimations()
                self.recordButton.layer.removeAllAnimations()
        })
    }
}
