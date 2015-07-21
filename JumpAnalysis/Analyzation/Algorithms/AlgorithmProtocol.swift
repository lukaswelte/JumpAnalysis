//
//  AlgorithmProtocol.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 16.03.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import UIKit

protocol AlgorithmProtocol {
    func name() -> String
    func calculateResult(sensorData: [SensorData]) -> Double
}