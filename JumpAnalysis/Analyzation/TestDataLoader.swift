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
            let path = NSBundle.mainBundle().pathForResource("Analyzation/data/\(i)", ofType: "json")
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
}