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
        let quaternion = Quaternion(w: 0.97894287109375, x: -0.068603515625, y: 0.18804931640625, z: 0.03900146484375)
        XCTAssertEqual(quaternion, quaternion)
    }
    
    func testCanBeConvertedToAndCreatedFromJSON() {
        let quaternion = Quaternion(w: 0.97894287109375, x: -0.068603515625, y: 0.18804931640625, z: 0.03900146484375)
        let jsonString = JSON(quaternion.toDictionary()).description
        
        let dictionary = JSON(data: jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
        let recreated =  Quaternion(fromDictionary: dictionary.dictionaryObject!)
        
        XCTAssertEqual(quaternion, recreated)
    }
}