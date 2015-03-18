//
//  AlgorithmParameter.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 18.03.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import Foundation

struct AlgorithmParameterSpecification {
    let min: Double
    let max: Double
    let step: Double
    let name: String
}

struct AlgorithmParameter {
    let value: Double
    let name: String
}