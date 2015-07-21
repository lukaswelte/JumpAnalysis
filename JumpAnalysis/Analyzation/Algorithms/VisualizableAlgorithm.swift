//
//  VisualizableAlgorithm.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 20.07.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import UIKit

class VisualizableAlgorithm: AlgorithmProtocol {
    func name() -> String {
        preconditionFailure("This method must be overridden")
    }
    
    func calculateResult(sensorData: [SensorData]) -> (visualizationInformation: [VisualizationInformation], result: Double) {
        preconditionFailure("This method must be overridden")
    }
    
    func getVisualizationInformation(sensorData: [SensorData]) -> [VisualizationInformation] {
        return calculateResult(sensorData).0
    }
    
    func calculateResult(sensorData: [SensorData]) -> Double {
        return calculateResult(sensorData).1
    }
}