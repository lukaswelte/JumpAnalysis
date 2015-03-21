//
//  AlgorithmProtocol.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 16.03.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import UIKit

protocol AlgorithmProtocol {
    var name: String { get }
    func calculateResult(sensorData: [SensorData]) -> Double
    
    func debugView(sensorData: [SensorData]) -> UIView
}

