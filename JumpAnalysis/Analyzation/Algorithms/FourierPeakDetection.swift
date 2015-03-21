//
//  FourierPeakDetection.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 21.03.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import UIKit
import Accelerate

class FourierPeakDetection : AlgorithmProtocol {
    
    var name = "FourierPeakDetection"
    
    func calculateResult(sensorData: [SensorData]) -> Double {
        var mutatingSensorData = sensorData
        mutatingSensorData.removeRange(0...100)
        for i in 0...100 {
            mutatingSensorData.removeLast()
        }
        
        let sortedByTime = mutatingSensorData.sorted { (a, b) -> Bool in
            return a.sensorTimeStampInMilliseconds < b.sensorTimeStampInMilliseconds
        }
        
        let fftFunc = fft(sortedByTime.map {s in Double(s.linearAcceleration.y)})
        let sortedFFT = fftFunc.sorted { (a, b) -> Bool in
            return a > b
        }
        
        
        var zipped: [(SensorData, Double)] = []
        for i in 0..<sortedByTime.count {
            let tuple: (SensorData, Double) = (sortedByTime[i], fftFunc[i])
            zipped.append(tuple)
        }

        
        let peaks = zipped.filter({e in e.1 > sortedFFT[10]})
        let firstPeak = peaks.first!.0
        let lastPeak = peaks.last!.0
        
        let duration = lastPeak.sensorTimeStampInMilliseconds - firstPeak.sensorTimeStampInMilliseconds
        return Double(duration)
    }
    
    func debugView(sensorData: [SensorData]) -> UIView {
        let view = Chart()
        view.labelColor = UIColor.clearColor()
        view.backgroundColor = UIColor.whiteColor()
        
        let sortedByTime = sensorData.sorted { (a, b) -> Bool in
            return a.sensorTimeStampInMilliseconds < b.sensorTimeStampInMilliseconds
        }
        let fftValues = fft(sortedByTime.map {s in Double(s.linearAcceleration.y)})
        
        var data : [ChartPoint] = []
        for i in 0..<sortedByTime.count {
            let yValue = Double(sortedByTime[i].linearAcceleration.y)
            let val = Float((yValue-fftValues[i]) * fftValues[i])
            data.append(ChartPoint(x: Float(sortedByTime[i].sensorTimeStampInMilliseconds), y: val))
        }
        
        view.addSeries(ChartSeries(data: data))
        return view
    }
}