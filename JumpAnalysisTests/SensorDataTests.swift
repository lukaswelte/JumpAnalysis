//
//  SensorDataTests.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 19.01.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import XCTest

class SensorDataTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func getSensorData() -> SensorData {
        return SensorData(sensorTimeStamp: 102, rawAcceleration: RawAcceleration(x: 21, y: -312, z: 31), linearAcceleration: LinearAcceleration(x: -12, y: 0, z: 13))
    }

    
    func testCanBeConvertedToJSON() {
        let rawAcceleration = RawAcceleration(x: 21, y: -312, z: 31)
        let sensorData = getSensorData()
        
        let jsonSensorData = JSON(sensorData.toDictionary()).description
        XCTAssertNotEqual("", jsonSensorData)
        
        let jsonArraySensorData = JSON([sensorData.toDictionary(), sensorData.toDictionary()]).description
        XCTAssertNotEqual("", jsonArraySensorData)
        
        XCTAssertNotEqual(jsonSensorData, jsonArraySensorData)
    }
    
    func testCanBeCreatedFromJson() {
        let sensorData = getSensorData()
        
        let jsonSensorData = JSON(sensorData.toDictionary()).description
        XCTAssertNotEqual("", jsonSensorData)
        
        let jsonArraySensorData = JSON([sensorData.toDictionary(), sensorData.toDictionary()]).description
        XCTAssertNotEqual("", jsonArraySensorData)
        
        XCTAssertNotEqual(jsonSensorData, jsonArraySensorData)
        
        
        let jsonValue = JSON(data: jsonSensorData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
        let recreatedData = SensorData(fromDictionary: jsonValue.dictionaryObject!)
        XCTAssertEqual(sensorData, recreatedData)
    }
    
    func testDoesEqualItself () {
        let sensorData = getSensorData()
        XCTAssertEqual(sensorData, sensorData)
    }

}
