//
//  ParameterizedAlgorithmProtocol.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 18.03.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import Foundation

protocol ParameterizedAlgorithmProtocol : AlgorithmProtocol {
    var parameterSpecification: [AlgorithmParameterSpecification] {get}
    
    init(parameters: [AlgorithmParameter])
    func factory(parameters: [AlgorithmParameter]) -> AlgorithmProtocol
    
    init()
}