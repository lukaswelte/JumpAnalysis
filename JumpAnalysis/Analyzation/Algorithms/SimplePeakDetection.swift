//
//  SimplePeakDetection.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 16.03.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import Foundation

class SimplePeakDetection : AlgorithmProtocol {
    var name = "SimplePeak"
    
    func calculateResult(sensorData: [SensorData]) -> Double {
        let sortedByTime = sensorData.sorted { (a, b) -> Bool in
            return a.sensorTimeStampInMilliseconds < b.sensorTimeStampInMilliseconds
        }
        
        let peaks = sortedByTime.filter({e in e.linearAcceleration.z > 6000})
        let firstPeak = peaks.first!
        let lastPeak = peaks.last!
        
        let duration = lastPeak.sensorTimeStampInMilliseconds - firstPeak.sensorTimeStampInMilliseconds
        return Double(duration)
    }
}