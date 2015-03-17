//
//  AnalyzationResult.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 17.03.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import Foundation

class AnalyzationResult {
    let algorithm : AlgorithmProtocol
    let testData: TestData
    let computedResult: Double
    let precision : Double
    
    init(algorithm: AlgorithmProtocol, testData: TestData, computedResult: Double) {
        self.algorithm = algorithm
        self.testData = testData
        self.computedResult = computedResult
        let jumpDuration = Double(self.testData.jumpDurationInMs)
        let difference = self.computedResult - jumpDuration
        let absDiff = abs(difference)
        let percentageError = absDiff / jumpDuration
        self.precision = 1 - percentageError
        let i = 0
    }
}