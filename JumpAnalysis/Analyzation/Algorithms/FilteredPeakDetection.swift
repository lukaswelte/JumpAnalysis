//
//  FilteredPeakDetection.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 21.03.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import Foundation

class FilteredPeakDetection : AlgorithmProtocol {
    var name = "FilteredPeakDetection"
    
    let lowPassFilterStrength = 0.9
    
    func calculateResult(sensorData: [SensorData]) -> Double {
        let sortedByTime = sensorData.sorted { (a, b) -> Bool in
            return a.sensorTimeStampInMilliseconds < b.sensorTimeStampInMilliseconds
        }
        
        var minValue: Double = Double.infinity
        var maxValue: Double = Double.NaN
        var maxPeakData: SensorData? = nil
        var minPeakData: SensorData? = nil
        var previousValue: Double = 0
        
        for data in sortedByTime {
            let currentVal: Double = Double(data.linearAcceleration.y)
            let currentFilteredVal: Double = minValue.isInfinite ? currentVal : previousValue * lowPassFilterStrength + currentVal * (1 - lowPassFilterStrength)
            
            if currentFilteredVal > maxValue || maxValue.isNaN {
                maxValue = currentFilteredVal
                maxPeakData = data
            } else if currentFilteredVal < minValue {
                minValue = currentFilteredVal
                minPeakData = data
            }
            
            previousValue = currentFilteredVal
        }
        
        var jumpDuration = 0
        if let minData = minPeakData, maxData = maxPeakData {
            jumpDuration = abs(minData.sensorTimeStampInMilliseconds - maxData.sensorTimeStampInMilliseconds)
        }
        
        return Double(jumpDuration)
    }
}