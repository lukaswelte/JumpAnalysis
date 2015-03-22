//
//  AlgorithmTestResult.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 21.03.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import Foundation

class AlgorithmTestResult {
    let analyzationResults: [AnalyzationResult]
    let averagePercentage: Double
    let standardDeviation: Double
    let bestPercentage: Double
    let worstPercentage: Double
    let algorithm: AlgorithmProtocol

    init(analyzationResults: [AnalyzationResult], algorithm: AlgorithmProtocol) {
        self.algorithm = algorithm
        self.analyzationResults = analyzationResults
        
        var bestPercentage: Double = -1
        var worstPercentage = Double.infinity
        var percentageSum: Double = 0.0
        
        for result in analyzationResults {
            percentageSum += result.precision
            if bestPercentage <= result.precision {
                bestPercentage = result.precision
            }
            if worstPercentage >= result.precision {
                worstPercentage = result.precision
            }
        }
        
        self.bestPercentage = bestPercentage
        self.worstPercentage = worstPercentage
        self.averagePercentage = percentageSum / Double(analyzationResults.count)
        self.standardDeviation = AlgorithmTestResult.standardDeviation(analyzationResults.map({a in a.relativePercentError}))
    }
    
    private class func standardDeviation(arr : [Double]) -> Double {
        let length = Double(arr.count)
        let avg = arr.reduce(0, combine: {$0 + $1}) / length
        let sumOfSquaredAvgDiff = arr.map { pow($0 - avg, 2.0)}.reduce(0, combine: {$0 + $1})
        return sqrt(sumOfSquaredAvgDiff / length)
    }
}