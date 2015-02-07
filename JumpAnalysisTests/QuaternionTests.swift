//
//  QuaternionTests.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 04.02.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import XCTest

class QuaternionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testDoesEqualItself() {
        let quaternion = Quaternion(w: 31, x: -312, y: 3123, z: 3123)
        XCTAssertEqual(quaternion, quaternion)
    }
    
    func testCanBeConvertedToAndCreatedFromJSON() {
        let quaternion = Quaternion(w: 213, x: -043, y: 123, z: 123)
        let jsonString = JSON(quaternion.toDictionary()).description
        
        let dictionary = JSON(data: jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
        let recreated =  Quaternion(fromDictionary: dictionary.dictionaryObject!)
        
        XCTAssertEqual(quaternion, recreated)
    }
}