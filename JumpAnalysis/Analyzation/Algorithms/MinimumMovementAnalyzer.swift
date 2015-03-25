//
//  MinimumMovementAnalyzer.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 25.03.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import UIKit

class MinimumMovementAnalyzer : ParameterizedAlgorithmProtocol {
    var name = "Min Move"
    
    var lastSamplesCount = 10
    var maxJumpDuration: Double = 850
    var peakMinDifferenceThreshold: Double = 10
    var peakMinAbsoluteThreshold: Double = 1600
    var jumpDurationFactor: Double = 2.6
    
    
    var parameterSpecification: [AlgorithmParameterSpecification] = [
        AlgorithmParameterSpecification(min: 1, max: 10, step: 1, name: "minLand")
    ]
    
    required init() {}
    
    required init(parameters: [AlgorithmParameter]) {
        for param in parameters {
            if param.name == "minLand" {
                self.lastSamplesCount = Int(param.value)
                self.name += " samples: \(self.lastSamplesCount)"
            }
        }
    }
    
    func factory(parameters: [AlgorithmParameter]) -> AlgorithmProtocol {
        return MinimumMovementAnalyzer(parameters: parameters)
    }
    
    private func getValueToAnalyze(sensorData: SensorData) -> Double {
        return Double(sensorData.linearAcceleration.y)
    }
    
    
    private func getFirstPeak(sensorData: [SensorData]) -> SensorData? {
        var lastSamples: [Double] = []
        var firstPeak: SensorData? = nil
        
        var oldAcceleration: Double = 0
        
        for data in sensorData {
            let valueToAnalyze = getValueToAnalyze(data)
            
            if lastSamples.count < lastSamplesCount {
                lastSamples.append(valueToAnalyze)
                continue;
            }
            //calculate average of last samples
            let currentAcceleration = lastSamples.reduce(0, combine: +) / Double(lastSamples.count)
            
            //check if significate movement
            if currentAcceleration-oldAcceleration > peakMinDifferenceThreshold && currentAcceleration > peakMinAbsoluteThreshold {
                firstPeak = data
                break;
            }
            
            oldAcceleration = currentAcceleration
            
            lastSamples.append(valueToAnalyze)
            if lastSamples.count > lastSamplesCount {
                lastSamples.removeAtIndex(0)
            }
        }
        
        return firstPeak
    }
    
    func calculateResult(sensorData: [SensorData]) -> Double {
        let sortedByTime = sensorData.sorted { (a, b) -> Bool in
            return a.sensorTimeStampInMilliseconds < b.sensorTimeStampInMilliseconds
        }
        
        var jumpDuration:Double = Double.infinity
        
        var reversedByTime = sortedByTime.reverse()
        while (jumpDuration > maxJumpDuration) {
            var startJumpPeak: SensorData? = getFirstPeak(sortedByTime)
            var endJumpPeak: SensorData? = getFirstPeak(reversedByTime)
            
            if let liftOffData = startJumpPeak, landingData = endJumpPeak {
                jumpDuration = Double(abs(landingData.sensorTimeStampInMilliseconds - liftOffData.sensorTimeStampInMilliseconds)) / jumpDurationFactor
                if jumpDuration > maxJumpDuration {
                    reversedByTime = reversedByTime.filter({s in s.sensorTimeStampInMilliseconds < liftOffData.sensorTimeStampInMilliseconds})
                }
            } else {
                jumpDuration = 0
            }
        }
        
        return Double(jumpDuration)
    }
    
    func debugView(sensorData: [SensorData]) -> UIView {
        let rootView = UIView()
        let view = Chart()
        view.labelColor = UIColor.clearColor()
        view.backgroundColor = UIColor.whiteColor()
        
        let sortedByTime = sensorData.sorted { (a, b) -> Bool in
            return a.sensorTimeStampInMilliseconds < b.sensorTimeStampInMilliseconds
        }
        

        var peakMinLine: [ChartPoint] = []
        var accelerationLine: [ChartPoint] = []
        var jumpArea: [ChartPoint] = []
        
        var algorithmSensorData = sortedByTime.reverse()
        var startJumpPeak: SensorData? = nil
        var endJumpPeak: SensorData? = nil
        var jumpDuration:Double = Double.infinity
        
        while (jumpDuration > maxJumpDuration) {
            startJumpPeak = getFirstPeak(sortedByTime)
            endJumpPeak = getFirstPeak(algorithmSensorData)
            
            if let liftOffData = startJumpPeak, landingData = endJumpPeak {
                jumpDuration = Double(abs(landingData.sensorTimeStampInMilliseconds - liftOffData.sensorTimeStampInMilliseconds)) / jumpDurationFactor
                if jumpDuration > maxJumpDuration {
                    algorithmSensorData = algorithmSensorData.filter({s in s.sensorTimeStampInMilliseconds < liftOffData.sensorTimeStampInMilliseconds})
                }
            } else {
                jumpDuration = 0
            }
        }
        
        
        var lastSamples: [Double] = []
        for i in 0..<sortedByTime.count {
            let valueToAnalyze = getValueToAnalyze(sortedByTime[i])
            
            let val = Float(valueToAnalyze)
            let x = Float(sortedByTime[i].sensorTimeStampInMilliseconds)
            
            let data = sortedByTime[i]
            
            if lastSamples.count < lastSamplesCount {
                lastSamples.append(valueToAnalyze)
                continue;
            }
            //calculate average of last samples
            let currentAcceleration = lastSamples.reduce(0, combine: +) / Double(lastSamples.count)
            accelerationLine.append(ChartPoint(x:x, y: Float(currentAcceleration)))
            peakMinLine.append(ChartPoint(x:x, y: Float(peakMinAbsoluteThreshold)))
            
            //start algorithm
            if let first = startJumpPeak, last = endJumpPeak {
                let rangePredicate = data.sensorTimeStampInMilliseconds >= first.sensorTimeStampInMilliseconds && data.sensorTimeStampInMilliseconds <= last.sensorTimeStampInMilliseconds
                let rangeTwo = data.sensorTimeStampInMilliseconds <= first.sensorTimeStampInMilliseconds && data.sensorTimeStampInMilliseconds >= last.sensorTimeStampInMilliseconds
                let predicate = first.sensorTimeStampInMilliseconds < last.sensorTimeStampInMilliseconds ? rangePredicate : rangeTwo
                if predicate {
                    jumpArea.append(ChartPoint(x:x, y: Float(currentAcceleration)))
                }
            }
            
            lastSamples.append(valueToAnalyze)
            if lastSamples.count > lastSamplesCount {
                lastSamples.removeAtIndex(0)
            }
        }
        
        view.addSeries(ChartSeries(data: accelerationLine))
        view.addSeries(ChartSeries(data: peakMinLine))
        
        let jumpSeries = ChartSeries(data: jumpArea)
        jumpSeries.area = true
        jumpSeries.color = UIColor.greenColor()
        view.addSeries(jumpSeries)
        
        return view
    }
}
