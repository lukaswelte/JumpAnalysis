//
//  FakeAlgortihmParamterized.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 18.03.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import Foundation

class FakeAlgorithmParameterized : ParameterizedAlgorithmProtocol {
    var name = "FakeAlgorithmParam"
    
    var parameterSpecification: [AlgorithmParameterSpecification] = []
    
    required init() {}
    
    required init(parameters: [AlgorithmParameter]) {
    }
    
    func factory(parameters: [AlgorithmParameter]) -> AlgorithmProtocol {
        return FakeAlgorithmParameterized(parameters: parameters)
    }
    
    func calculateResult(sensorData: [SensorData]) -> Double {
        return 250
    }
}