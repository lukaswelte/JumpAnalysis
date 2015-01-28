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
