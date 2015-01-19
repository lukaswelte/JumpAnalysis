//
//  SensorData.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 18.01.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import Foundation

class SensorData {
    let creationDate: NSDate
    let gravity: Gravity = Gravity(x: 0,y: 0,z: 0)
    let linearAcceleration: LinearAcceleration = LinearAcceleration(x: 0.0, y: 0.0, z: 0.0)
    let quaternion: Quaternion = Quaternion(w: 0,x: 0,y: 0,z: 0)
    let rawAcceleration: RawAcceleration = RawAcceleration(x: 0.0, y: 0.0, z: 0.0)
    let isUpperSensor: Bool = false
    
    private class func sensorIsUpperSensor(sensorID: Int) -> Bool {
        return sensorID == 1
    }
    
    init(sensorID: Int, rawAcceleration: RawAcceleration, quaternion: Quaternion, creationDate: NSDate = NSDate()) {
        self.creationDate = creationDate
        self.isUpperSensor = SensorData.sensorIsUpperSensor(sensorID)
        self.rawAcceleration = rawAcceleration
        self.quaternion = quaternion
    }
}