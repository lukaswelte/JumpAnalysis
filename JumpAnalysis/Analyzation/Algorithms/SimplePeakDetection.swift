//
//  SimplePeakDetection.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 16.03.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import UIKit

class SimplePeakDetection : AlgorithmProtocol {
    private var algorithmName = "FakeAlgorithmParam"
    func name() -> String { return self.algorithmName }
    
    func parameterSpecification() -> [AlgorithmParameterSpecification] {
        return []
    }
    
    let threshold: Int = 3000
    
    func calculateResult(sensorData: [SensorData]) -> Double {
        let sortedByTime = sensorData.sorted { (a, b) -> Bool in
            return a.sensorTimeStampInMilliseconds < b.sensorTimeStampInMilliseconds
        }
        
        let peaks = sortedByTime.filter({e in e.linearAcceleration.y > self.threshold})
        let firstPeak = peaks.first!
        let lastPeak = peaks.last!
        
        let duration = lastPeak.sensorTimeStampInMilliseconds - firstPeak.sensorTimeStampInMilliseconds
        return Double(duration)
    }
    
    func debugView(sensorData: [SensorData]) -> UIView {
        let view = Chart()
        view.gridColor = UIColor.clearColor()
        view.labelColor = UIColor.clearColor()
        view.lineWidth = 1
        view.backgroundColor = UIColor.whiteColor()
        
        /** Algorithm **/
        let sortedByTime = sensorData.sorted { (a, b) -> Bool in
            return a.sensorTimeStampInMilliseconds < b.sensorTimeStampInMilliseconds
        }
        
        let peaks = sortedByTime.filter({e in e.linearAcceleration.y > self.threshold})
        
        var previousPeak = peaks.first
        var firstPeak: SensorData? = nil
        var lastPeak: SensorData? = nil
        
        for peak in peaks {
            if peak.linearAcceleration.y < previousPeak!.linearAcceleration.y {
                let timeDiffBetweenPeaks = peak.sensorTimeStampInMilliseconds - previousPeak!.sensorTimeStampInMilliseconds
                let timeBetweenPeaksIsHigh = timeDiffBetweenPeaks > 100
                if  timeBetweenPeaksIsHigh || peak.linearAcceleration.y < previousPeak!.linearAcceleration.y {
                    if (firstPeak != nil) {
                        if timeBetweenPeaksIsHigh {
                            lastPeak = peak
                        } else {
                            lastPeak = previousPeak
                        }
                    } else {
                        firstPeak = previousPeak
                    }
                }
            }
            previousPeak = peak
        }
        
        /** Algorithm End **/
        
        var thresholdLine: [ChartPoint] = []
        var accelerationLine: [ChartPoint] = []
        var jumpArea: [ChartPoint] = []
        
        for data in sortedByTime {
            let x = Float(data.sensorTimeStampInMilliseconds)
            accelerationLine.append(ChartPoint(x:x, y:Float(data.linearAcceleration.y)))
            thresholdLine.append(ChartPoint(x:x, y:Float(self.threshold)))
            
            if let first = firstPeak, last = lastPeak {
                if (data.sensorTimeStampInMilliseconds >= first.sensorTimeStampInMilliseconds && data.sensorTimeStampInMilliseconds <= last.sensorTimeStampInMilliseconds) {
                    jumpArea.append(ChartPoint(x:x, y:Float(data.linearAcceleration.y)))
                }
            }
        }
        
        view.addSeries(ChartSeries(data: thresholdLine))
        view.addSeries(ChartSeries(data: accelerationLine))
        
        let jumpSeries = ChartSeries(data: jumpArea)
        jumpSeries.area = true
        jumpSeries.color = UIColor.greenColor()
        view.addSeries(jumpSeries)
        
        return view
    }
}