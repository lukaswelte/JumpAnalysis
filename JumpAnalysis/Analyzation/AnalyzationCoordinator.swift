//
//  AnalyzationCoordinator.swift
//  
//
//  Created by Lukas Welte on 16.03.15.
//
//

import Foundation

private let _AnalyzationCoordinator = AnalyzationCoordinator()

class AnalyzationCoordinator {
    class var sharedInstance: AnalyzationCoordinator {
        return _AnalyzationCoordinator
    }
    
    let testData = TestDataLoader().retrieveTestData()
    
    let algorithms: [AlgorithmProtocol]
    
    static let statAlgorithms: [AlgorithmProtocol] = [FakeAlgorithm(), SimplePeakDetection()]
    
    static let parameterizedAlgorithmClasses : [ParameterizedAlgorithmProtocol] = [FakeAlgorithmParameterized(), SimplePeakDetectionParameterized()]
    
    static func generateAlgorithmsFromParameterizedAlgorithms(algorithmClasses: [ParameterizedAlgorithmProtocol]) -> [AlgorithmProtocol] {
        var algorithmList: [AlgorithmProtocol] = []
        for aClass in algorithmClasses {
            //var parameterMap = [String:[AlgorithmParameter]]()
            for paramSpec in aClass.parameterSpecification {
                var params: [AlgorithmParameter] = []
                var current = paramSpec.min
                while current<=paramSpec.max {
                    let param = AlgorithmParameter(value: current, name: paramSpec.name)
                    params.append(param)
                    
                    algorithmList.append(aClass.factory([param]))
                    current += paramSpec.step
                }
                //parameterMap.updateValue(params, forKey: paramSpec.name)
            }
        }
        
        return algorithmList
    }
    
    init() {
        var arr : [AlgorithmProtocol] = AnalyzationCoordinator.statAlgorithms
        arr += AnalyzationCoordinator.generateAlgorithmsFromParameterizedAlgorithms(AnalyzationCoordinator.parameterizedAlgorithmClasses)
        self.algorithms = arr
    }
    
    func testRunAndCompareAlgorithms() {
        println("Starting algorithms tests...")
        
        var results: [AnalyzationResult] = []
        for data in testData {
            for algorithm in algorithms {
                results.append(AnalyzationResult(algorithm: algorithm, testData: data, computedResult: algorithm.calculateResult(data.sensorData)))
            }
        }
        
        println("Finished running algorithm tests.")
        println("Starting comparison...")
        
        for algorithm in algorithms {
            let analyzationResults = results.filter({a in a.algorithm.name == algorithm.name})
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
            
            var averagePercentage: Double = percentageSum / Double(analyzationResults.count)
            var standardDev = standardDeviation(analyzationResults.map({a in a.precision}))
            
            println("Algorithm: \(algorithm.name) \t Best: \(bestPercentage) \t Worst: \(worstPercentage) \t Average: \(averagePercentage) \t Standard Dev: \(standardDev)")
        }
        
        println("Finished comparison.")
    }
    
    private func standardDeviation(arr : [Double]) -> Double {
        let length = Double(arr.count)
        let avg = arr.reduce(0, combine: {$0 + $1}) / length
        let sumOfSquaredAvgDiff = arr.map { pow($0 - avg, 2.0)}.reduce(0, combine: {$0 + $1})
        return sqrt(sumOfSquaredAvgDiff / length)
    }
}