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
    let percentError: Double
    let relativePercentError : Double
    
    init(algorithm: AlgorithmProtocol, testData: TestData, computedResult: Double) {
        self.algorithm = algorithm
        self.testData = testData
        self.computedResult = computedResult
        let jumpDuration = Double(self.testData.jumpDurationInMs)
        let difference = self.computedResult - jumpDuration
        let absDiff = abs(difference)
        self.percentError = difference / jumpDuration
        self.relativePercentError = absDiff / jumpDuration
        self.precision = 1 - self.relativePercentError
        let i = 0
    }
}