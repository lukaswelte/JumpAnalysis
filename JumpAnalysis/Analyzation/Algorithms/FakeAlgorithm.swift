//
//  FakeAlgorithm.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 17.03.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import Foundation

class FakeAlgorithm : AlgorithmProtocol {
    var name = "FakeAlgorithm"
    
    func calculateResult(sensorData: [SensorData]) -> Double {
        return 301.5
    }
}