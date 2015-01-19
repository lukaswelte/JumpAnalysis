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
    @IBOutlet weak var rawAccelerometerChart: Chart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let series = ChartSeries([1.2,1.4,5.0,-1.3,0.5])
        series.color = ChartColors.greenColor()
        self.rawAccelerometerChart.addSeries(series)
    }
    
    @IBAction func startStopMeasurement(sender: UIButton) {
        self.sensorDataSession.startStopMeasurement({sender.setTitle("Start Measurement", forState: .Normal)})
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

