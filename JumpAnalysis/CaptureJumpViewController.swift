//
//  SecondViewController.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 18.01.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import UIKit

class CaptureJumpViewController: UIViewController {
    
    var sensorDataSession = SensorDataSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func startStopMeasurement(sender: UIButton) {
        self.sensorDataSession.startStopMeasurement({sender.setTitle("Start Measurement", forState: .Normal)})
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

