//
//  VectorTests.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 04.02.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import XCTest

class VectorTest: XCTestCase {
    func testDoesEqualItself() {
        let vector = Vector(x: -0.068603515625, y: 0.18804931640625, z: 0.03900146484375)
        XCTAssertEqual(vector, vector)
    }
    
//    func testCanBeConvertedToAndCreatedFromJSON() {
//        let vector = Vector(x: -0.068603515625, y: -0.1880493164062, z: 0.03900146484375)
//        let jsonString = JSON(vector.toDictionary()).description
//        
//        let dictionary = JSON(data: jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
//        let recreated =  Vector(fromDictionary: dictionary.dictionaryObject!)
//        
//        XCTAssertEqual(vector, recreated)
//    }
}
