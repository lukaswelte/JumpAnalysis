//
//  TestDataLoader.swift
//  
//
//  Created by Lukas Welte on 16.03.15.
//
//

import Foundation

class TestDataLoader {
    func retrieveTestData(max: Int? = nil) -> [TestData] {
        var loadedData:[TestData] = []
        
        var array = NSMutableArray()
        for i in 0...67 {
            array.addObject(i)
        }
        
        var lock = NSLock()
        array.enumerateObjectsWithOptions(NSEnumerationOptions.Concurrent, usingBlock: { (obj: AnyObject!, index: Int, outStop: UnsafeMutablePointer<ObjCBool>) -> Void in
            let i = obj as! Int
            let predicate = i==10// || i==18 || i==61
            if !predicate {
                let path = NSBundle.mainBundle().pathForResource("\(i)", ofType: "json")
                if let filePath = path {
                    if let data = NSData(contentsOfMappedFile: filePath) {
                        let json = JSON(data: data, options: NSJSONReadingOptions.AllowFragments, error: nil)
                        let dictionary = json.dictionaryObject
                        let testData = TestData(fromDictionary: dictionary!)
                        lock.lock()
                        loadedData.append(testData)
                        lock.unlock()
                    }
                }
            }
        });
        
        return loadedData
    }
    
    func retrieveSingleTestData(index: Int=57) -> TestData {
        var result : TestData? = nil
        let path = NSBundle.mainBundle().pathForResource("\(index)", ofType: "json")
        if let filePath = path {
            if let data = NSData(contentsOfMappedFile: filePath) {
                let json = JSON(data: data, options: NSJSONReadingOptions.AllowFragments, error: nil)
                let dictionary = json.dictionaryObject
                result = TestData(fromDictionary: dictionary!)
            }
        }
        return result!
    }
}