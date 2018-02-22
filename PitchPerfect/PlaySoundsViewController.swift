//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Lucas César  Nogueira Fonseca on 22/02/2018.
//  Copyright © 2018 Lucas César  Nogueira Fonseca. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    var recordAudioURL:URL!
    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var lowButton: UIButton!
    @IBOutlet weak var hightButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var recordedAudioURL:URL!
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    enum ButtonType: Int {
        case slow = 0, fast, chipmunk, vader, echo, reverb
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureUI(.notPlaying)
    }
    
    
    @IBAction func playSoundAction(_ sender: Any) {
    }
    @IBAction func stopSoundAction(_ sender: Any) {
    }
}
