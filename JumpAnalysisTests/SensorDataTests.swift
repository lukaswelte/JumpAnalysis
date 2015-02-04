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
    
    func testGravityIsAlwaysCalculatedTheSameWay() {
        let quaternion = Quaternion(w: 0.97894287109, x: -0.068603515, y: 0.18804931640625, z: 0.03946484375)
        let rawAcceleration = RawAcceleration(x: 0.068515625, y: 0.1880440625, z: 0.0390014675)
        let sensorData = SensorData(sensorID: 0, sensorTimeStamp: 102, rawAcceleration: rawAcceleration, quaternion: quaternion)
        
        let sensorData2 = SensorData(sensorID: 0, sensorTimeStamp: 102, rawAcceleration: rawAcceleration, quaternion: quaternion)
        
        XCTAssertEqual(sensorData.gravity, sensorData2.gravity)
    }
    
    func testLinearAccelerationIsAlwaysCalculatedTheSameWay() {
        let quaternion = Quaternion(w: 0.97894287109, x: -0.068603515, y: 0.18804931640625, z: 0.03946484375)
        let rawAcceleration = RawAcceleration(x: 0.068515625, y: 0.1880440625, z: 0.0390014675)
        let sensorData = SensorData(sensorID: 0, sensorTimeStamp: 102, rawAcceleration: rawAcceleration, quaternion: quaternion)
        
        let sensorData2 = SensorData(sensorID: 0, sensorTimeStamp: 102, rawAcceleration: rawAcceleration, quaternion: quaternion)
        
        XCTAssertEqual(sensorData.linearAcceleration, sensorData2.linearAcceleration)
    }

    
    func testCanBeConvertedToJSON() {
        let quaternion = Quaternion(w: 0.97894287109375, x: -0.068603515625, y: 0.18804931640625, z: 0.03900146484375)
        let rawAcceleration = RawAcceleration(x: 0.068603515625, y: 0.18804931640625, z: 0.03900146484375)
        let sensorData = SensorData(sensorID: 0, sensorTimeStamp: 102, rawAcceleration: rawAcceleration, quaternion: quaternion)
        
        let jsonSensorData = JSON(sensorData.toDictionary()).description
        XCTAssertNotEqual("", jsonSensorData)
        
        let jsonArraySensorData = JSON([sensorData.toDictionary(), sensorData.toDictionary()]).description
        XCTAssertNotEqual("", jsonArraySensorData)
        
        XCTAssertNotEqual(jsonSensorData, jsonArraySensorData)
    }
    
    func testCanBeCreatedFromJson() {
        let quaternion = Quaternion(w: 0.97894287109, x: -0.068603515, y: 0.18804931640625, z: 0.03946484375)
        let rawAcceleration = RawAcceleration(x: 0.068515625, y: 0.1880440625, z: 0.0390014675)
        let sensorData = SensorData(sensorID: 0, sensorTimeStamp: 102, rawAcceleration: rawAcceleration, quaternion: quaternion)
        
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
        let quaternion = Quaternion(w: 0.97894287109375, x: -0.068603515625, y: 0.18804931640625, z: 0.03900146484375)
        let rawAcceleration = RawAcceleration(x: 0.068603515625, y: 0.18804931640625, z: 0.03900146484375)
        let sensorData = SensorData(sensorID: 0, sensorTimeStamp: 102, rawAcceleration: rawAcceleration, quaternion: quaternion)
        XCTAssertEqual(sensorData, sensorData)
    }
    

    func testPerformanceGravityFromQuaternion() {
        // This is an example of a performance test case.
        
        let quaternion = Quaternion(w: 0.97894287109375, x: -0.068603515625, y: 0.18804931640625, z: 0.03900146484375)
        self.measureBlock() {
            // Put the code you want to measure the time of here.
            let gravity = SensorData.calculateGravity(quaternion)
        }
    }
    
    func testPerformanceLinearAccelerationFromQuaternion() {
        // This is an example of a performance test case.
        
        let quaternion = Quaternion(w: 0.97894287109375, x: -0.068603515625, y: 0.18804931640625, z: 0.03900146484375)
        let rawAcceleration = RawAcceleration(x: 0.068603515625, y: 0.18804931640625, z: 0.03900146484375)
        
        self.measureBlock() {
            // Put the code you want to measure the time of here.
            let linearAcceleration = SensorData.calculateLinearAcceleration(rawAcceleration, quaternion: quaternion)
        }
    }

}
