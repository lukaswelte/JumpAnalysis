//
//  DemoPeakDetection.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 23.07.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//


import UIKit

class DemoPeakDetection: VisualizableAlgorithm,ParameterizedAlgorithmProtocol {
    var algorithmName = "Peak"
    
    override func name() -> String {
        return self.algorithmName
    }
    
    func parameterSpecification() -> [AlgorithmParameterSpecification] {
        return [
            AlgorithmParameterSpecification(min: 1000, max: 3100, step: 100, name: "threshold")
        ]
    }
    
    required override init() {}
    
    required init(parameters: [AlgorithmParameter]) {
        for param in parameters {
            if param.name == "threshold" {
                self.threshold = Int(param.value)
                self.algorithmName += " threshold: \(self.threshold)"
            }
        }
    }
    
    func factory(parameters: [AlgorithmParameter]) -> AlgorithmProtocol {
        return DemoPeakDetection(parameters: parameters)
    }
    
    var threshold: Int = 4000
    
    override func calculateResult(sensorData: [SensorData]) -> (visualizationInformation: [VisualizationInformation], result: Double) {
        var visualizationInformation: [VisualizationInformation] = [Threshold(color: UIColor.lightGrayColor(), description: "Threshold", value: Double(self.threshold))]
        
        var firstPeak: SensorData? = nil
        var lastPeak: SensorData? = nil
        var dataOverThreshold: [SensorData] = []
        var previousValue: Int = Int.min
        var wasNegativeAfterFirst: Bool = false
        var foundFirstPeak: Bool = false
        
        for data in sensorData {
            let currentValue = data.linearAcceleration.y
            if  currentValue >= self.threshold {
                //Data is above threshold so potential peak
                dataOverThreshold.append(data)
                
            } else if (previousValue >= self.threshold) {
                if wasNegativeAfterFirst {
                    
                    //Was above the threshold so determine the threshold of the area that was above the threshold
                    for potentialPeak in dataOverThreshold {
                        if let last = lastPeak {
                            if last.linearAcceleration.y < potentialPeak.linearAcceleration.y {
                                lastPeak = potentialPeak
                            }
                        } else {
                            lastPeak = potentialPeak
                        }
                    }
                    
                } else {
                    //Was above the threshold so determine the threshold of the area that was above the threshold
                    for potentialPeak in dataOverThreshold {
                        if let first = firstPeak {
                            if first.linearAcceleration.y <= potentialPeak.linearAcceleration.y {
                                firstPeak = potentialPeak
                            }
                        } else {
                            firstPeak = potentialPeak
                            foundFirstPeak = true
                        }
                    }
                }
                
                dataOverThreshold = []
                
            } else {
                if firstPeak != nil && lastPeak != nil {
                    break
                }
            }
            
            if foundFirstPeak && currentValue < 0 {
                wasNegativeAfterFirst = true
            }
            
            previousValue = currentValue
        }
        
        /*
        if let first = firstPeak {
            visualizationInformation.append(Peak(color: UIColor.blackColor(), description: "First", timestamp: first.sensorTimeStampInMilliseconds))
        }*/
        
        /*if let last = lastPeak {
            visualizationInformation.append(Peak(color: UIColor.blackColor(), description: "Last", timestamp: last.sensorTimeStampInMilliseconds))
        }*/
        
        if let first = firstPeak, last = lastPeak {
            let duration = last.sensorTimeStampInMilliseconds - first.sensorTimeStampInMilliseconds
            visualizationInformation.append(Range(color: UIColor.greenColor(), description: "Hop", startTime: first.sensorTimeStampInMilliseconds, endTime: last.sensorTimeStampInMilliseconds))
            return (visualizationInformation, Double(duration))
        }
        return (visualizationInformation, Double(0))
    }
}