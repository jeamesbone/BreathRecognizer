//
//  BreathRecognizer.swift
//  BreathRecognizer
//
//  Created by Jeames Bone on 26/08/2015.
//  Copyright (c) 2015 Jeames Bone. All rights reserved.
//

import Foundation
import AVFoundation

class BreathRecognizer: NSObject {
    /// Threshold in decibels (-160 < threshold < 0)
    let threshold: Float
    
    var recorder: AVAudioRecorder? = nil
    
    var isBreathing = false {
        willSet(newBreathing) {
            // Run the callback function only on change
            if isBreathing != newBreathing {
                self.breathFunction(newBreathing)
            }
        }
    }

    var breathFunction: (Bool) -> ()

    init(threshold: Float, breathFunction: (Bool) -> ()) {
        self.threshold = threshold
        self.breathFunction = breathFunction
        
        super.init()
        
        self.setupAudioRecorder()
    }
    
    func setupAudioRecorder() {
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryRecord, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        
        let url = NSURL.fileURLWithPath(NSTemporaryDirectory().stringByAppendingPathComponent("tmpSound"))
        
        let settings: [NSString: AnyObject] =
        [AVSampleRateKey: 44100,
            AVFormatIDKey: kAudioFormatAppleLossless,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.Max.rawValue]
        
        recorder = AVAudioRecorder(URL: url, settings: settings, error: nil)
        recorder?.prepareToRecord()
        recorder?.meteringEnabled = true
        recorder?.record()
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: "tick", userInfo: nil, repeats: true)
    }
    
    func tick() {
        if let recorder = recorder {
            recorder.updateMeters()
            
            // Uses a weighted average of the average power and peak power for the time period.
            let average = recorder.averagePowerForChannel(0) * 0.4
            let peak = recorder.peakPowerForChannel(0) * 0.6
            let combinedPower = average + peak
            
            println(combinedPower)
            
            if (combinedPower > threshold) {
                isBreathing = true
            } else {
                isBreathing = false
            }
        }
    }
}
