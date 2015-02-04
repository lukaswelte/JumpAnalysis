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
    
    @IBOutlet weak var rawAccelerometerChart: Chart!
    @IBOutlet weak var quaternionChart: Chart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.resetCharts()
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.resetCharts()
    }
    
    func resetCharts() {
        self.quaternionChart.removeSeries()
        self.quaternionChart.setNeedsDisplay()
        self.rawAccelerometerChart.removeSeries()
        self.rawAccelerometerChart.setNeedsDisplay()
    }
    
    @IBAction func startStopMeasurement(sender: UIButton) {
        self.sensorDataSession.startStopMeasurement({
            self.isCollectingData = !self.isCollectingData
            let title:String = self.isCollectingData ? "Stop Measurement" : "Start Measurement"
            sender.setTitle(title, forState: .Normal)
            if (!self.isCollectingData) {
                self.measurementDidFinish()
            } else {
                self.resetCharts()
            }
        })
    }
    
    func measurementDidFinish() {
        let upperSensorData = self.sensorDataSession.upperSensorData()
        let sensorDataDictionaries = upperSensorData.map({sensorData in sensorData.toDictionary()})
        let json = JSON(sensorDataDictionaries)
        let jsonString = json.description
        FileHandler.writeToFile(NSDate().description.stringByAppendingPathExtension("json")!, content: jsonString)
        
        self.updateCharts(upperSensorData)
    }
    
    func updateCharts(upperSensorData: [SensorData]) {
        self.resetCharts()
        
        if upperSensorData.count <= 0 {
            return
        }
        
        let rawAccelerometerSeries = self.rawAccelerometerChartSeries(upperSensorData)
        self.rawAccelerometerChart.addSeries(rawAccelerometerSeries)
        self.rawAccelerometerChart.setNeedsDisplay()
        
        let quaternionSeries = self.quaternionChartSeries(upperSensorData)
        self.quaternionChart.addSeries(quaternionSeries)
        self.quaternionChart.setNeedsDisplay()
    }
    
    func rawAccelerometerChartSeries(data:[SensorData]) -> [ChartSeries] {
        let rawAccelerations = data.map({sensorData in sensorData.rawAcceleration})
        
        let yValues = rawAccelerations.map({acceleration in Float(acceleration.y)})
        let yChart = ChartSeries(yValues)
        yChart.color = ChartColors.greenColor()
        
        let xValues = rawAccelerations.map({acceleration in Float(acceleration.x)})
        let xChart = ChartSeries(xValues)
        xChart.color = ChartColors.blueColor()
        
        let zValues = rawAccelerations.map({acceleration in Float(acceleration.z)})
        let zChart = ChartSeries(zValues)
        zChart.color = ChartColors.redColor()
        
        return [yChart, xChart, zChart]
    }
    
    func quaternionChartSeries(data:[SensorData]) -> [ChartSeries] {
        let quaternions = data.map({sensorData in sensorData.quaternion})
        
        let wValues = quaternions.map({quaternion in Float(quaternion.w)})
        let wChart = ChartSeries(wValues)
        wChart.color = ChartColors.yellowColor()
        
        let yValues = quaternions.map({quaternion in Float(quaternion.y)})
        let yChart = ChartSeries(yValues)
        yChart.color = ChartColors.greenColor()
        
        let xValues = quaternions.map({quaternion in Float(quaternion.x)})
        let xChart = ChartSeries(xValues)
        xChart.color = ChartColors.blueColor()
        
        let zValues = quaternions.map({quaternion in Float(quaternion.z)})
        let zChart = ChartSeries(zValues)
        zChart.color = ChartColors.redColor()
        
        return [wChart, yChart, xChart, zChart]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

