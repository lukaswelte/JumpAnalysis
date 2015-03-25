//
//  NegativeAreaAnalyzer.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 22.03.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import UIKit

class NegativeAreaAnalyzer : ParameterizedAlgorithmProtocol {
    var name = "Negative Area"
    
    let accelerationThreshold:Double = 4000
    var landingThreshold: Double = 250
    var lastSamplesCount = 5
    var minJumpDuration = 100
    var takeOffThreshold:Double = 0
    var minLandedThreshold: Double = 300

    let minNegativePassedThreshold: Double = -6000
    
    var parameterSpecification: [AlgorithmParameterSpecification] = [
        AlgorithmParameterSpecification(min: 300, max: 300, step: 1, name: "minLand")
    ]
    
    required init() {}
    
    required init(parameters: [AlgorithmParameter]) {
        for param in parameters {
            if param.name == "minLand" {
                self.minLandedThreshold = param.value
                self.name += " minLand: \(self.minLandedThreshold)"
            }
        }
    }
    
    func factory(parameters: [AlgorithmParameter]) -> AlgorithmProtocol {
        return NegativeAreaAnalyzer(parameters: parameters)
    }
    
    private func getValueToAnalyze(sensorData: SensorData) -> Double {
        return Double(sensorData.linearAcceleration.y)
    }
    
    
    func calculateResult(sensorData: [SensorData]) -> Double {
        let sortedByTime = sensorData.sorted { (a, b) -> Bool in
            return a.sensorTimeStampInMilliseconds < b.sensorTimeStampInMilliseconds
        }
        
        var lastSamples: [Double] = []
        var startJumpPeak: SensorData? = nil
        var liftOff: SensorData? = nil
        var landingPeak: SensorData? = nil
        var oldAcceleration: Double = 0

        var hasPassedMinNegThreshold = false
        var maxNegativeAcceleration:Double = 0
        for data in sortedByTime {
            let valueToAnalyze = getValueToAnalyze(data)
            
            if lastSamples.count < lastSamplesCount {
                lastSamples.append(valueToAnalyze)
                continue;
            }
            //calculate average of last samples
            let currentAcceleration = lastSamples.reduce(0, combine: +) / Double(lastSamples.count)
            
            //check for peak
            if currentAcceleration > accelerationThreshold && startJumpPeak == nil && currentAcceleration < oldAcceleration {
                //peak detected
                startJumpPeak = data
            } else if startJumpPeak != nil {
                
                //Has lift-off begun
                if  currentAcceleration <= takeOffThreshold && liftOff == nil {
                    //Lift off happend
                    liftOff = data
                } else if liftOff != nil {

                    if !hasPassedMinNegThreshold && currentAcceleration <= minNegativePassedThreshold {
                        hasPassedMinNegThreshold = true
                    } else if hasPassedMinNegThreshold {
                        
                        //Jumper did land?
                        if currentAcceleration < oldAcceleration && maxNegativeAcceleration > currentAcceleration {
                            maxNegativeAcceleration = currentAcceleration
                        } else if currentAcceleration >= landingThreshold || (currentAcceleration < oldAcceleration && maxNegativeAcceleration < currentAcceleration && abs(maxNegativeAcceleration-currentAcceleration)>4000 && abs(oldAcceleration-currentAcceleration)>self.minLandedThreshold) {
                            if (data.sensorTimeStampInMilliseconds-liftOff!.sensorTimeStampInMilliseconds) > minJumpDuration {
                                landingPeak = data
                                //We landed so no more data needed to process
                                break
                            }
                        }
                    }
                }
            }
            
            oldAcceleration = currentAcceleration
            
            
            lastSamples.append(valueToAnalyze)
            if lastSamples.count > lastSamplesCount {
                lastSamples.removeAtIndex(0)
            }
        }
        
        var jumpDuration:Int = 0
        if let liftOffData = liftOff, landingData = landingPeak {
            jumpDuration = landingData.sensorTimeStampInMilliseconds - liftOffData.sensorTimeStampInMilliseconds
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
        
        var jumpThresholdLine: [ChartPoint] = []
        var landingThresholdLine: [ChartPoint] = []
        var accelerationLine: [ChartPoint] = []
        var jumpArea: [ChartPoint] = []
        
        var lastSamples: [Double] = []
        var startJumpPeak: SensorData? = nil
        var liftOff: SensorData? = nil
        var landingPeak: SensorData? = nil
        var oldAcceleration: Double = 0
        
        var hasPassedMinNegThreshold = false
        var maxNegativeAcceleration:Double = 0
        for i in 0..<sortedByTime.count {
            let valueToAnalyze = getValueToAnalyze(sortedByTime[i])
            
            let val = Float(valueToAnalyze)
            let x = Float(sortedByTime[i].sensorTimeStampInMilliseconds)
            
            jumpThresholdLine.append(ChartPoint(x: x, y: Float(accelerationThreshold)))
            landingThresholdLine.append(ChartPoint(x: x, y: Float(landingThreshold)))
            let data = sortedByTime[i]
            
            /*** Algorithm ***/
            if lastSamples.count < lastSamplesCount {
                lastSamples.append(valueToAnalyze)
                continue;
            }
            //calculate average of last samples
            let currentAcceleration = lastSamples.reduce(0, combine: +) / Double(lastSamples.count)
            accelerationLine.append(ChartPoint(x: x, y: Float(currentAcceleration)))
            
            //check for peak
            if currentAcceleration > accelerationThreshold && startJumpPeak == nil && currentAcceleration < oldAcceleration {
                //peak detected
                startJumpPeak = data
            } else if startJumpPeak != nil {
                
                //Has lift-off begun
                if  currentAcceleration <= takeOffThreshold && liftOff == nil {
                    //Lift off happend
                    liftOff = data
                } else if liftOff != nil {
                    
                    if !hasPassedMinNegThreshold && currentAcceleration <= minNegativePassedThreshold {
                        hasPassedMinNegThreshold = true
                    } else if hasPassedMinNegThreshold {
                        
                        //Jumper did land?
                        if currentAcceleration < oldAcceleration && maxNegativeAcceleration > currentAcceleration {
                            maxNegativeAcceleration = currentAcceleration
                        } else if currentAcceleration >= landingThreshold || (currentAcceleration < oldAcceleration && maxNegativeAcceleration < currentAcceleration && abs(maxNegativeAcceleration-currentAcceleration)>self.minLandedThreshold && abs(oldAcceleration-currentAcceleration)>self.minLandedThreshold)  {
                            if (data.sensorTimeStampInMilliseconds-liftOff!.sensorTimeStampInMilliseconds) > minJumpDuration {
                                if landingPeak == nil {
                                    landingPeak = data
                                }
                            }
                        }
                    }
                }
            }
            
            if landingPeak == nil && liftOff != nil {
                jumpArea.append(ChartPoint(x: x, y: Float(currentAcceleration)))
            }
            
            oldAcceleration = currentAcceleration
            
            
            lastSamples.append(valueToAnalyze)
            if lastSamples.count > lastSamplesCount {
                lastSamples.removeAtIndex(0)
            }
        }
        
        //view.addSeries(ChartSeries(data: data))
        view.addSeries(ChartSeries(data: jumpThresholdLine))
        view.addSeries(ChartSeries(data: landingThresholdLine))
        view.addSeries(ChartSeries(data: accelerationLine))
        
        let jumpSeries = ChartSeries(data: jumpArea)
        jumpSeries.area = true
        jumpSeries.color = UIColor.greenColor()
        view.addSeries(jumpSeries)
        
        return view
    }
}