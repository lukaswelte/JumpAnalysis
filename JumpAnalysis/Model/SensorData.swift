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
    let gravity: Gravity
    let linearAcceleration: LinearAcceleration
    let quaternion: Quaternion
    let rawAcceleration: RawAcceleration
    let isUpperSensor: Bool
    
    private class func sensorIsUpperSensor(sensorID: Int) -> Bool {
        return sensorID == 1
    }
    
    init(sensorID: Int, rawAcceleration: RawAcceleration, quaternion: Quaternion, creationDate: NSDate = NSDate()) {
        self.creationDate = creationDate
        self.isUpperSensor = SensorData.sensorIsUpperSensor(sensorID)
        self.rawAcceleration = rawAcceleration
        self.quaternion = quaternion
        self.gravity = SensorData.calculateGravity(self.quaternion)
        self.linearAcceleration = SensorData.calculateLinearAcceleration(self.rawAcceleration, quaternion: self.quaternion)
    }
    
    class func calculateLinearAcceleration(rawAcceleration: RawAcceleration, quaternion: Quaternion) -> LinearAcceleration {
        let x = rawAcceleration.x - (2 * (quaternion.x * quaternion.z - quaternion.w * quaternion.y)) * 8192;
        let y = rawAcceleration.y - (2 * (quaternion.w * quaternion.x + quaternion.y * quaternion.z)) * 8192;
        let z = rawAcceleration.z - (quaternion.w * quaternion.w - quaternion.x * quaternion.x - quaternion.y * quaternion.y + quaternion.z * quaternion.z) * 8192;
        
        return LinearAcceleration(x: x, y: y, z: z)
    }
    
    class func calculateGravity(quaternion: Quaternion) -> Gravity {
        
        let x = 2 * (quaternion.x * quaternion.z - quaternion.w * quaternion.y)
        let y = 2 * (quaternion.w * quaternion.x + quaternion.y * quaternion.z)
        let z = quaternion.w * quaternion.w - quaternion.x * quaternion.x - quaternion.y * quaternion.y + quaternion.z * quaternion.z
        
        return Gravity(x: x, y: y, z: z)
    }
}