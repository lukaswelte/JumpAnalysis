//
//  SecondViewController.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 18.01.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import UIKit

class CaptureJumpViewController: UIViewController {
    
    var isCollectingData = false
    var sensorDataSession = SensorDataSession()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var weightInKgTextField: UITextField!
    @IBOutlet weak var heightInMeterTextField: UITextField!
    @IBOutlet weak var jumpNumberLabel: UILabel!
    @IBOutlet weak var jumpNumberStepper: UIStepper!
    @IBOutlet weak var additionalInformationTextField: UITextField!
    @IBOutlet weak var linearAccelerometerChart: Chart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    @IBAction func jumpNumberChanged(sender: UIStepper) {
        self.setJumpNumber(Int(sender.value))
    }
    
    override func viewDidAppear(animated: Bool) {
        self.updateJumpNumberUI()
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.resetCharts()
    }
    
    func resetCharts() {
        self.linearAccelerometerChart.removeSeries()
        self.linearAccelerometerChart.setNeedsDisplay()
    }
    
    @IBAction func startStopMeasurement(sender: UIButton) {
        self.sensorDataSession.startStopMeasurement({
            self.isCollectingData = !self.isCollectingData
            let title:String = self.isCollectingData ? "Stop Measurement" : "Start Measurement"
            sender.setTitle(title, forState: .Normal)
            if (!self.isCollectingData) {
                self.measurementDidFinish()
            } else {
                self.sensorDataSession.resetData()
                self.resetCharts()
            }
        })
    }
    
    func convertStringToDouble(inputString: String) -> Double {
        let dotNumberString = inputString.stringByReplacingOccurrencesOfString(",", withString: ".", options: NSStringCompareOptions.LiteralSearch, range: nil)
        return (dotNumberString as NSString).doubleValue
    }
    
    func measurementDidFinish() {
        let upperSensorData = self.sensorDataSession.allSensorData()
        let sensorDataDictionaries = upperSensorData.map({sensorData in sensorData.toDictionary()})
        let jumpDictionary = ["id":self.jumpNumber(),"name":self.nameTextField.text, "weightInKg":convertStringToDouble(self.weightInKgTextField.text), "heightInMeter":convertStringToDouble(self.heightInMeterTextField.text), "additionalInformation":self.additionalInformationTextField.text, "sensorData":sensorDataDictionaries]
        let json = JSON(jumpDictionary)
        let jsonString = json.description
        FileHandler.writeToFile("\(self.jumpNumber())-\(self.nameTextField.text).json", content: jsonString)
        self.updateCharts(upperSensorData)
        
        setJumpNumber(jumpNumber()+1)
    }
    
    private func setJumpNumber(newJumpNumber: Int) {
        NSUserDefaults.standardUserDefaults().setInteger(newJumpNumber, forKey: "captureJumpNumber")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        self.updateJumpNumberUI()
    }
    
    func jumpNumber() -> Int {
        return NSUserDefaults.standardUserDefaults().integerForKey("captureJumpNumber")
    }
    
    func updateJumpNumberUI() {
        let currentJumpNumber = jumpNumber()
        self.jumpNumberLabel.text = "\(currentJumpNumber)"
        self.jumpNumberStepper.value = Double(currentJumpNumber)
    }
    
    func updateCharts(sensorData: [SensorData]) {
        self.resetCharts()
        
        if sensorData.count <= 0 {
            return
        }
        
        let linearAccelerometerSeries = self.linearAccelerationChartSeries(sensorData)
        self.linearAccelerometerChart.addSeries(linearAccelerometerSeries)
        self.linearAccelerometerChart.setNeedsDisplay()
    }
    
    func linearAccelerationChartSeries(data:[SensorData]) -> [ChartSeries] {
        let linearAccelerations = data.map({sensorData in sensorData.linearAcceleration})
        var yValues: [Float] = []
        var xValues: [Float] = []
        var zValues: [Float] = []
        
        for acceleration: LinearAcceleration in linearAccelerations {
            yValues.append(Float(acceleration.y))
            xValues.append(Float(acceleration.x))
            zValues.append(Float(acceleration.z))
        }
        
        let yChart = ChartSeries(yValues)
        yChart.color = ChartColors.greenColor()
        
        let xChart = ChartSeries(xValues)
        xChart.color = ChartColors.blueColor()
        
        let zChart = ChartSeries(zValues)
        zChart.color = ChartColors.redColor()
        
        return [yChart, xChart, zChart]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
}

