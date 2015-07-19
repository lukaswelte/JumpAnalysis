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
    
    lazy var testData = TestDataLoader().retrieveTestData()//.filter({t in t.jumpDistanceInCm < 100 && t.jumpDurationInMs<300})
    
    let algorithms: [AlgorithmProtocol]
    
    /** FourerPeakDetection/Filtering is not used right now **/
    static let statAlgorithms: [AlgorithmProtocol] = [FakeAlgorithm()]//[FakeAlgorithm(),  SimplePeakDetection()]
    
    static let parameterizedAlgorithmClasses : [ParameterizedAlgorithmProtocol] = [NegativeAreaAnalyzer(),SimplePeakDetectionParameterized()]//[NegativeAreaAnalyzer(), MinimumMovementAnalyzer(), SimplePeakDetectionParameterized(), FilteredPeakDetection()]
    
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
            let analyzationResult = AnalyzationResult(algorithm: algorithm, testData: data, computedResult: algorithm.calculateResult(data.sensorData))
            lock.lock()
            results.append(analyzationResult)
            lock.unlock()
        });
        
        return AlgorithmTestResult(analyzationResults: results, algorithm: algorithm)
    }
}