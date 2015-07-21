//
//  FakeAlgortihmParamterized.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 18.03.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import UIKit

class FakeAlgorithmParameterized : ParameterizedAlgorithmProtocol {
    private var algorithmName = "FakeAlgorithmParam"
    func name() -> String { return self.algorithmName }
    
    func parameterSpecification() -> [AlgorithmParameterSpecification] {
        return []
    }
    
    required init() {}
    
    required init(parameters: [AlgorithmParameter]) {
    }
    
    func factory(parameters: [AlgorithmParameter]) -> AlgorithmProtocol {
        return FakeAlgorithmParameterized(parameters: parameters)
    }
    
    func calculateResult(sensorData: [SensorData]) -> Double {
        return 250
    }
    
    func debugView(sensorData: [SensorData]) -> UIView {
        return UIView()
    }
}