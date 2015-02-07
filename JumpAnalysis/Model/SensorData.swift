//
//  SensorData.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 18.01.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import Foundation

class SensorData: Equatable {
    let creationDate: NSDate
    let linearAcceleration: LinearAcceleration
    let rawAcceleration: RawAcceleration
    let sensorTimeStampInMilliseconds: Int
    
    private class func sensorIsUpperSensor(sensorID: Int) -> Bool {
        return sensorID == 1
    }
    
    init(sensorTimeStamp: Int, rawAcceleration: RawAcceleration, linearAcceleration: LinearAcceleration, creationDate: NSDate = NSDate()) {
        self.sensorTimeStampInMilliseconds = sensorTimeStamp
        self.creationDate = creationDate
        self.rawAcceleration = rawAcceleration
        self.linearAcceleration = linearAcceleration
    }
    
    
//MARK: JSON Methods
    func toDictionary() -> Dictionary<String, AnyObject> {
        return ["sensorTimeStamp":self.sensorTimeStampInMilliseconds, "creationDate":creationDate.timeIntervalSince1970, "rawAccelerometer":self.rawAcceleration.toDictionary(), "linearAcceleration":self.linearAcceleration.toDictionary()]
    }
    
    init(fromDictionary: Dictionary<String, AnyObject>) {
        self.sensorTimeStampInMilliseconds = fromDictionary["sensorTimeStamp"] as Int;
        self.creationDate = NSDate(timeIntervalSince1970: fromDictionary["creationDate"] as NSTimeInterval)
        self.rawAcceleration = RawAcceleration(fromDictionary: fromDictionary["rawAccelerometer"] as Dictionary<String, AnyObject>)
        self.linearAcceleration = LinearAcceleration(fromDictionary: fromDictionary["linearAcceleration"] as Dictionary<String, AnyObject>)
    }
}

func ==(lhs: SensorData, rhs: SensorData) -> Bool {
    return lhs.sensorTimeStampInMilliseconds == rhs.sensorTimeStampInMilliseconds && lhs.rawAcceleration == rhs.rawAcceleration && lhs.linearAcceleration == rhs.linearAcceleration //&& lhs.creationDate.isEqualToDate(rhs.creationDate)
    //TODO: compare CreationDate
}

