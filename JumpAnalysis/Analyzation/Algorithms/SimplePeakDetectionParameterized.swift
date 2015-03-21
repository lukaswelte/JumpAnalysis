//
//  SimplePeakDetectionParameterized.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 18.03.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import UIKit

class SimplePeakDetectionParameterized : ParameterizedAlgorithmProtocol {
    
    var parameterSpecification: [AlgorithmParameterSpecification] = [
        AlgorithmParameterSpecification(min: 5000, max: 10000, step: 1000, name: "threshold")
    ]
    
    var name = "SimplePeak"
    
    required init() {
        
    }
    
    required init(parameters: [AlgorithmParameter]) {
        for param in parameters {
            if param.name == "threshold" {
                self.threshold = Int(param.value)
                self.name += " Threshold: \(self.threshold)"
            }
        }
    }
    
    func factory(parameters: [AlgorithmParameter]) -> AlgorithmProtocol {
        return SimplePeakDetectionParameterized(parameters: parameters)
    }
    
    var threshold: Int = 0
    
    
    func calculateResult(sensorData: [SensorData]) -> Double {
        let sortedByTime = sensorData.sorted { (a, b) -> Bool in
            return a.sensorTimeStampInMilliseconds < b.sensorTimeStampInMilliseconds
        }
        
        let peaks = sortedByTime.filter({e in e.linearAcceleration.z > self.threshold})
        let firstPeak = peaks.first
        let lastPeak = peaks.last
        
        if let first = firstPeak, last = lastPeak {
            let duration = last.sensorTimeStampInMilliseconds - first.sensorTimeStampInMilliseconds
            return Double(duration)
        }
        
        
        return 0
    }
    
    func debugView(sensorData: [SensorData]) -> UIView {
        return UIView()
    }
}