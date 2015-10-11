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

    init(threshold: Float, breathFunction: (Bool) -> ()) throws {
        self.threshold = threshold
        self.breathFunction = breathFunction

        super.init()

        try self.setupAudioRecorder()
    }

    func setupAudioRecorder() throws {
        try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryRecord)
        try AVAudioSession.sharedInstance().setActive(true)

        let url = NSURL.fileURLWithPath(NSTemporaryDirectory()).URLByAppendingPathComponent("tmpSound")

        var settings = [String: AnyObject]()
        settings[AVSampleRateKey] = 44100.0
        settings[AVFormatIDKey] = Int(kAudioFormatAppleLossless)
        settings[AVNumberOfChannelsKey] = 1
        settings[AVEncoderAudioQualityKey] = AVAudioQuality.Max.rawValue

        try recorder = AVAudioRecorder(URL: url, settings: settings)
        recorder?.prepareToRecord()
        recorder?.meteringEnabled = true
        recorder?.record()

        NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: "tick", userInfo: nil, repeats: true)
    }

    func tick() {
        if let recorder = recorder {
            recorder.updateMeters()

            // Uses a weighted average of the average power and peak power for the time period.
            let average = recorder.averagePowerForChannel(0) * 0.4
            let peak = recorder.peakPowerForChannel(0) * 0.6
            let combinedPower = average + peak

            isBreathing = (combinedPower > threshold)
        }
    }
}
