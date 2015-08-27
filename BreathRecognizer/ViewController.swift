//
//  ViewController.swift
//  BreathRecognizer
//
//  Created by Jeames Bone on 26/08/2015.
//  Copyright (c) 2015 Jeames Bone. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var breathRecognizer: BreathRecognizer! = nil
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        breathRecognizer = BreathRecognizer(threshold: -15) { [unowned self] isBreathing in
            if isBreathing {
                self.bottomConstraint.constant = 300
            } else {
                self.bottomConstraint.constant = 50
            }
        }
    }
}

