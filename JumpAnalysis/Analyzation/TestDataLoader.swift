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
        
        for i in 0...67 {
            /*if i==10 || i==18 || i==61 {
                continue
            }*/
            let path = NSBundle.mainBundle().pathForResource("\(i)", ofType: "json")
            if let filePath = path {
                if let data = NSData(contentsOfMappedFile: filePath) {
                    let json = JSON(data: data, options: NSJSONReadingOptions.AllowFragments, error: nil)
                    let dictionary = json.dictionaryObject
                    let testData = TestData(fromDictionary: dictionary!)
                    loadedData.append(testData)
                }                
            }
        }
        
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