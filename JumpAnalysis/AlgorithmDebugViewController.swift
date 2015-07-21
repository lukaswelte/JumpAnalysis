//
//  AlgorithmDebugViewController.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 21.03.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import UIKit

class AlgorithmDebugViewController : UIViewController {
    
    var algorithm: AlgorithmProtocol = FakeAlgorithm()
    var testData: TestData = TestDataLoader().retrieveSingleTestData()
    var dataChartSeries: [ChartSeries] = []
    
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var footLabel: UILabel!
    @IBOutlet weak var manualResultLabel: UILabel!
    @IBOutlet weak var algorithmResultLabel: UILabel!
    @IBOutlet weak var originalDataChart: Chart!
    @IBOutlet weak var debugViewPlaceHolder: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Debug \(algorithm.name()) with Data \(testData.id)"
        self.debugViewPlaceHolder.backgroundColor = UIColor.whiteColor()
        
        self.originalDataChart.gridColor = UIColor.clearColor()
        let sortedByTime = testData.sensorDataSortedByTime()
        let chartPoints:[ChartPoint] = sortedByTime.map {(s: SensorData) -> ChartPoint in return ChartPoint(x:Float(s.sensorTimeStampInMilliseconds), y:Float(s.linearAcceleration.y))}
        let chartSeries = ChartSeries(data: chartPoints)
        self.originalDataChart.addSeries(chartSeries)
        self.dataChartSeries = [chartSeries]
        
        self.weightLabel.text = "\(testData.jumperWeightInKg) kg"
        self.heightLabel.text = "\(testData.jumperHeightInCm) cm"
        self.footLabel.text = testData.isLeftFoot ? "left" : "right"
        self.manualResultLabel.text = "\(testData.jumpDurationInMs)"
        self.algorithmResultLabel.text = NSString(format: "%.2f", self.algorithm.calculateResult(testData.sensorData)) as String
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let visualizableAlgorithm = self.algorithm as? VisualizableAlgorithm {
            let visualizationInformation = visualizableAlgorithm.getVisualizationInformation(self.testData.sensorData)
            var chartSeries: [ChartSeries] = []
            
            let sortedByTime = testData.sensorDataSortedByTime()
            
            for information in visualizationInformation {
                switch information {
                case let v as ValueAtTime:
                    var series = ChartSeries(data: [ChartPoint(x: Float(v.timestamp), y: Float(v.value))])
                    series.color = v.color
                    chartSeries.append(series)
                    
                case let v as Threshold:
                    let chartPoints:[ChartPoint] = sortedByTime.map {(s: SensorData) -> ChartPoint in return ChartPoint(x:Float(s.sensorTimeStampInMilliseconds), y:Float(v.value))}
                    var series = ChartSeries(data: chartPoints)
                    series.color = v.color
                    chartSeries.append(series)
                    
                case let v as Peak:
                    let radiusInMs = 10
                    let chartPointsAtTimeStamp = sortedByTime.filter {(s: SensorData) -> Bool in return s.sensorTimeStampInMilliseconds >= v.timestamp - radiusInMs && s.sensorTimeStampInMilliseconds <= v.timestamp + radiusInMs}
                    let chartPoints:[ChartPoint] = chartPointsAtTimeStamp.map {(s: SensorData) -> ChartPoint in return ChartPoint(x:Float(s.sensorTimeStampInMilliseconds), y:Float(s.linearAcceleration.y))}
                    var series = ChartSeries(data: chartPoints)
                    series.color = v.color
                    chartSeries.append(series)
                    
                case let v as Event:
                    let chartPointsAtTimeStamp = sortedByTime.filter {(s: SensorData) -> Bool in return s.sensorTimeStampInMilliseconds == v.timestamp}
                    let chartPoints:[ChartPoint] = chartPointsAtTimeStamp.map {(s: SensorData) -> ChartPoint in return ChartPoint(x:Float(s.sensorTimeStampInMilliseconds), y:Float(s.linearAcceleration.y))}
                    var series = ChartSeries(data: chartPoints)
                    series.color = v.color
                    chartSeries.append(series)
                    
                case let v as Range:
                    let chartPointsAtTimeStamp = sortedByTime.filter {(s: SensorData) -> Bool in return s.sensorTimeStampInMilliseconds >= v.startTime && s.sensorTimeStampInMilliseconds <= v.endTime}
                    let chartPoints:[ChartPoint] = chartPointsAtTimeStamp.map {(s: SensorData) -> ChartPoint in return ChartPoint(x:Float(s.sensorTimeStampInMilliseconds), y:Float(s.linearAcceleration.y))}
                    var series = ChartSeries(data: chartPoints)
                    series.color = v.color
                    series.area = true
                    chartSeries.append(series)
                    
                default:
                    println("not implemented")
                }
            }
            
            let debugView = Chart()
            debugView.gridColor = UIColor.clearColor()
            debugView.labelColor = UIColor.clearColor()
            debugView.lineWidth = 1
            debugView.backgroundColor = UIColor.whiteColor()
            
            debugView.addSeries(self.dataChartSeries)
            debugView.addSeries(chartSeries)
            debugView.frame = CGRectMake(0, 0, self.debugViewPlaceHolder.frame.width, self.debugViewPlaceHolder.frame.height)
            self.debugViewPlaceHolder.addSubview(debugView)
        }
    }
}
