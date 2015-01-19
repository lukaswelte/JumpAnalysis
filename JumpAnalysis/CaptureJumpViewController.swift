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
    var isCollectingData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        communicationManager.sensorDataDelegate = self
    }
    
    @IBAction func startStopMeasurement(sender: UIButton) {
        if (self.isCollectingData) {
            self.communicationManager.stopReceivingSensorData()
            sender.setTitle("Start Measurement", forState: .Normal)
            self.isCollectingData = false
        } else {
            self.waitForBluetoothToStart {
                self.communicationManager.startReceivingSensorData()
                self.isCollectingData = true
                sender.setTitle("Stop Measurement", forState: .Normal)
            }
        }
    }
    
    func waitForBluetoothToStart(after: ()->()) -> Void {
        if (communicationManager.isAbleToReceiveSensorData()) {
            NSLog("After called")
            after()
        } else {
            delay(0.5) {
                self.waitForBluetoothToStart(after)
            }
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//Mark: SensorDataDelegate
    func didReceiveData(sensorData: SensorData) {
        if (!self.isCollectingData) {
            return
        }
        NSLog("Received Data: %@", sensorData.creationDate)
    }
}

