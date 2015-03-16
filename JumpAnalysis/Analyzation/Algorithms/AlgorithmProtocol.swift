//
//  AlgorithmProtocol.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 16.03.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import Foundation

protocol AlgorithmProtocol {
    func calculateResult(sensorData: [SensorData]) -> Double
}
