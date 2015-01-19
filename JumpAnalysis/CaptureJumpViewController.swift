//
//  SecondViewController.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 18.01.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import UIKit

class CaptureJumpViewController: UIViewController, SensorDataDelegate {
     let communicationManager = ArduinoCommunicationManager.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        communicationManager.sensorDataDelegate = self
        communicationManager.startReceivingSensorData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//Mark: SensorDataDelegate
    func didReceiveData(sensorData: SensorData) {
        NSLog("Received Data: %@", sensorData.creationDate)
    }
}

