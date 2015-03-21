//
//  FakeAlgorithm.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 17.03.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import UIKit

class FakeAlgorithm : AlgorithmProtocol {
    var name = "FakeAlgorithm"
    
    func calculateResult(sensorData: [SensorData]) -> Double {
        return 301.5
    }
    
    func debugView(sensorData: [SensorData]) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.redColor()
        return view
    }
}