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
    
    @IBAction func startStopMeasurement(sender: UIButton) {
        self.sensorDataSession.startStopMeasurement({
            self.isCollectingData = !self.isCollectingData
            let title:String = self.isCollectingData ? "Stop Measurement" : "Start Measurement"
            sender.setTitle(title, forState: .Normal)
            if (!self.isCollectingData) {
                self.measurementDidFinish()
            }
        })
    }
    
    func measurementDidFinish() {
        //self.updateCharts()
        
        
        let lowerSensorData = self.sensorDataSession.lowerSensorData()
        let sensorDataDictionaries = lowerSensorData.map({sensorData in sensorData.toDictionary()})
        let json = JSON(sensorDataDictionaries)
        let jsonString = json.description
        FileHandler.writeToFile(NSDate().description.stringByAppendingPathExtension("json")!, content: jsonString)
    }
    
    func updateCharts() {
        self.rawAccelerometerChart.removeSeries()
        
        let lowerSensorData = self.sensorDataSession.lowerSensorData()
        let rawAccelerometerSeries = self.rawAccelerometerChartSeries(lowerSensorData)
        self.rawAccelerometerChart.addSeries(rawAccelerometerSeries)
        self.rawAccelerometerChart.setNeedsDisplay()
        
        self.quaternionChart.removeSeries()
        
        let quaternionSeries = self.quaternionChartSeries(self.sensorDataSession.lowerSensorData())
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

