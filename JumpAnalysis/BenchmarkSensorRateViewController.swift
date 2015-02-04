//
//  BenchmarkSensorRateViewController.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 26.01.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import UIKit
import Foundation
import CoreMotion

class BenchmarkSensorRateViewController: UIViewController, SensorDataDelegate {

    var communicationManager = ArduinoCommunicationManager.sharedInstance
    
    var upperSensorPackets: Int = 0
    var lowerSensorPackets: Int = 0
    
    let sensorRateInterval = NSTimeInterval(1.0)
    
    var timer: NSTimer? = nil
    
    let motionManager: CMMotionManager = CMMotionManager()
    
    @IBOutlet weak var upperSensorRateLabel: UILabel!
    @IBOutlet weak var lowerSensorRateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }
    
    override func viewDidAppear(animated: Bool) {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("evaluateRate"), userInfo: nil, repeats: true)
        self.resetPacketCounts()
        self.communicationManager.sensorDataDelegate = self
        
        self.waitForBluetoothToStart { () -> () in
            self.communicationManager.startReceivingSensorData()
        }
        
        self.motionManager.accelerometerUpdateInterval = NSTimeInterval(0.01)
        motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.currentQueue(), withHandler: { (deviceMotion, error) -> Void in
            self.lowerSensorPackets += 1
        })
    }
    
    func evaluateRate() {
        let upperSensorRate = 1 / Float(upperSensorPackets)
        
        let lowerSensorRate = 1 / Float(lowerSensorPackets)
        
        self.upperSensorRateLabel.text = NSString(format: "%d updates/s", upperSensorPackets)
        self.lowerSensorRateLabel.text = NSString(format: "%d updates/s", lowerSensorPackets)
        
        self.resetPacketCounts()
    }
    
    func resetPacketCounts() {
        self.upperSensorPackets = 0
        self.lowerSensorPackets = 0
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.motionManager.stopAccelerometerUpdates()
        
        self.communicationManager.stopReceivingSensorData()
        self.communicationManager.sensorDataDelegate = nil
        
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func waitForBluetoothToStart(after: ()->()) -> Void {
        if (self.communicationManager.isAbleToReceiveSensorData()) {
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
    

//MARK: Sensor Data Delegate
    func didReceiveData(data: SensorData) {
        if data.isUpperSensor {
            self.upperSensorPackets += 1
        } else {
            self.lowerSensorPackets += 1
        }
    }

}
