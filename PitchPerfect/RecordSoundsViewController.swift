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
        stopRecordingButton.isEnabled = false
        UIApplication.shared.statusBarStyle = .lightContent
        
        //Here to can set the division line of the navigation invisible, I set a empty image both on background an shadow
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    
    @IBAction func recordAudio(_ sender: Any) {
        animateLabel()
        recordingLabel.text = "Recording in progress"
        stopRecordingButton.isEnabled = true
        recordButton.isEnabled = false
        
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
        stopAnimateLabel()
        recordingLabel.text = "Tap to Record"
        stopRecordingButton.isEnabled = false
        recordButton.isEnabled = true
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    // MARK: - AudioRecorder
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: segueIdentifier, sender: audioRecorder.url)
        } else {
            //Trait problems here
        }
    }
    
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordAudioURL = sender as! URL
            playSoundsVC.recordAudioURL = recordAudioURL
        }
    }
    
    
    
    // MARK: - Animation
    func animateLabel() {
        UIView.animate(withDuration: 0.8, delay: 0, options: [.repeat, .autoreverse], animations: {
           self.recordButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.view.layoutIfNeeded()
            self.recordingLabel.alpha = 0.3
        }, completion: nil)
    }
    
    func stopAnimateLabel() {
        UIView.animate(withDuration: 0.5, animations: {
            self.recordingLabel.alpha = 1
            self.recordButton.transform = CGAffineTransform.identity
        }, completion: { _ in
                self.recordingLabel.layer.removeAllAnimations()
                self.recordButton.layer.removeAllAnimations()
        })
    }
}
