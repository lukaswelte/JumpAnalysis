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
    
    lazy var testData = TestDataLoader().retrieveTestData()
    
    let algorithms: [AlgorithmProtocol]
    
    static let algorithmList: [AlgorithmProtocol] = [DemoPeakDetection()]
    
    func testRunAndCompareAlgorithms() -> [AlgorithmTestResult] {
        println("Starting algorithms tests...")
        
        var analyzationResults: [AlgorithmTestResult] = []
        for algorithm in algorithms {
            let result = testSingleAlgorithm(algorithm)
            analyzationResults.append(result)
        }
        
        println("Finished comparison.")
        return analyzationResults
    }
    
    func testSingleAlgorithm(algorithm: AlgorithmProtocol) -> AlgorithmTestResult {
        var results: [AnalyzationResult] = []
        
        var array = NSArray(array: testData)
        var lock = NSLock()
        array.enumerateObjectsWithOptions(NSEnumerationOptions.Concurrent, usingBlock: { (obj: AnyObject!, index: Int, outStop: UnsafeMutablePointer<ObjCBool>) -> Void in
            let data: TestData = obj as! TestData
            let analyzationResult = AnalyzationResult(algorithm: algorithm, testData: data, computedResult: algorithm.calculateResult(data.sensorDataSortedByTime()))
            lock.lock()
            results.append(analyzationResult)
            lock.unlock()
        });
        
        return AlgorithmTestResult(analyzationResults: results, algorithm: algorithm)
    }
    
    static func generateAlgorithmsFromParameterizedAlgorithm(algorithmClass: ParameterizedAlgorithmProtocol) -> [AlgorithmProtocol] {
        var algorithmList: [AlgorithmProtocol] = []
        let parameterSpecifications = algorithmClass.parameterSpecification()
        for paramSpec in parameterSpecifications {
            var params: [AlgorithmParameter] = []
            var current = paramSpec.min
            while current<=paramSpec.max {
                let param = AlgorithmParameter(value: current, name: paramSpec.name)
                params.append(param)
                
                algorithmList.append(algorithmClass.factory([param]))
                current += paramSpec.step
            }
        }
        
        if parameterSpecifications.isEmpty {
            algorithmList = [algorithmClass.factory([])]
        }
        
        return algorithmList
    }
    
    init() {
        var arr : [AlgorithmProtocol] = []
        for algorithm in AnalyzationCoordinator.algorithmList {
            if let a = algorithm as? ParameterizedAlgorithmProtocol {
                arr += AnalyzationCoordinator.generateAlgorithmsFromParameterizedAlgorithm(a)
            } else {
                arr += [algorithm]
            }
        }
        self.algorithms = arr
    }
}