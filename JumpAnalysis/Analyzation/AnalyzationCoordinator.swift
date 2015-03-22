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
    
    lazy var testData = TestDataLoader().retrieveTestData()//.filter({t in t.jumpDistanceInCm < 100})
    
    let algorithms: [AlgorithmProtocol]
    
    /** FourerPeakDetection/Filtering is not used right now **/
    static let statAlgorithms: [AlgorithmProtocol] = []//[FakeAlgorithm(), SimplePeakDetection()]
    
    static let parameterizedAlgorithmClasses : [ParameterizedAlgorithmProtocol] = [NegativeAreaAnalyzer()]//[FakeAlgorithmParameterized(), SimplePeakDetectionParameterized(), FilteredPeakDetection()]
    
    static func generateAlgorithmsFromParameterizedAlgorithms(algorithmClasses: [ParameterizedAlgorithmProtocol]) -> [AlgorithmProtocol] {
        var algorithmList: [AlgorithmProtocol] = []
        for aClass in algorithmClasses {
            //TODO: enable for more than one parameter
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
    
    func testRunAndCompareAlgorithms() -> [AlgorithmTestResult] {
        println("Starting algorithms tests...")
        
        var analyzationResults: [AnalyzationResult] = []
        for data in testData {
            for algorithm in algorithms {
                analyzationResults.append(AnalyzationResult(algorithm: algorithm, testData: data, computedResult: algorithm.calculateResult(data.sensorData)))
            }
        }
        
        println("Finished running algorithm tests.")
        println("Starting comparison...")
        
        var algorithmResults: [AlgorithmTestResult] = []
        for algorithm in algorithms {
            let analyzationResults = analyzationResults.filter({a in a.algorithm.name == algorithm.name})
            algorithmResults.append(AlgorithmTestResult(analyzationResults: analyzationResults, algorithm: algorithm))
        }
        
        println("Finished comparison.")
        return algorithmResults
    }
    
    func testSingleAlgorithm(algorithm: AlgorithmProtocol) -> AlgorithmTestResult {
        var results: [AnalyzationResult] = []
        for data in testData {
            results.append(AnalyzationResult(algorithm: algorithm, testData: data, computedResult: algorithm.calculateResult(data.sensorData)))

        }
        return AlgorithmTestResult(analyzationResults: results, algorithm: algorithm)
    }
}