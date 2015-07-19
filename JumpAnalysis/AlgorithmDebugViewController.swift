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
    
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var footLabel: UILabel!
    @IBOutlet weak var manualResultLabel: UILabel!
    @IBOutlet weak var algorithmResultLabel: UILabel!
    @IBOutlet weak var originalDataChart: Chart!
    @IBOutlet weak var debugViewPlaceHolder: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Debug \(algorithm.name) with Data \(testData.id)"
        
        self.originalDataChart.gridColor = UIColor.clearColor()
        let sortedByTime = testData.sensorData.sorted { (a, b) -> Bool in
            return a.sensorTimeStampInMilliseconds < b.sensorTimeStampInMilliseconds
        }
        let chartPoints:[ChartPoint] = sortedByTime.map {(s: SensorData) -> ChartPoint in return ChartPoint(x:Float(s.sensorTimeStampInMilliseconds), y:Float(s.linearAcceleration.y))}
        let chartSeries = ChartSeries(data: chartPoints)
        self.originalDataChart.addSeries(chartSeries)
        
        self.weightLabel.text = "\(testData.jumperWeightInKg) kg"
        self.heightLabel.text = "\(testData.jumperHeightInCm) cm"
        self.footLabel.text = testData.isLeftFoot ? "left" : "right"
        self.manualResultLabel.text = "\(testData.jumpDurationInMs)"
        self.algorithmResultLabel.text = NSString(format: "%.2f", self.algorithm.calculateResult(testData.sensorData)) as String
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let debugView = self.algorithm.debugView(testData.sensorData)
        debugView.frame = CGRectMake(0, 0, self.debugViewPlaceHolder.frame.width, self.debugViewPlaceHolder.frame.height)
        self.debugViewPlaceHolder.addSubview(debugView)
    }
}
