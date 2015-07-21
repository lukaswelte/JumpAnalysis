//
//  ParameterizedAlgorithmProtocol.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 18.03.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import Foundation

protocol ParameterizedAlgorithmProtocol : AlgorithmProtocol {
    func parameterSpecification() -> [AlgorithmParameterSpecification]
    
    func factory(parameters: [AlgorithmParameter]) -> AlgorithmProtocol
    
    init(parameters: [AlgorithmParameter])
    init()
}