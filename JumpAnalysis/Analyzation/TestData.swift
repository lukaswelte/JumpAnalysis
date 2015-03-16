//
//  TestData.swift
//  
//
//  Created by Lukas Welte on 16.03.15.
//
//

import Foundation

class TestData: Equatable {
    let id : Int
    let isLeftFoot: Bool
    let jumperName: String
    let jumperWeightInKg: Double
    let jumperHeightInCm: Int
    let jumpDurationInMs: Int
    let jumpDistanceInCm: Int
    let sensorData: [SensorData]
    
    
    init(id: Int, isLeftFoot: Bool, jumperName: String, jumperWeightInKg: Double, jumperHeightInCm: Int, jumpDurationInMs: Int, jumpDistanceInCm: Int, sensorData: [SensorData]) {
        self.id = id
        self.isLeftFoot = isLeftFoot
        self.jumperName = jumperName
        self.jumperWeightInKg = jumperWeightInKg
        self.jumperHeightInCm = jumperHeightInCm
        self.jumpDurationInMs = jumpDurationInMs
        self.jumpDistanceInCm = jumpDistanceInCm
        self.sensorData = sensorData
    }
    

//MARK: JSON method
    init(fromDictionary: Dictionary<String, AnyObject>) {
        self.sensorTimeStampInMilliseconds = fromDictionary["sensorTimeStamp"] as! Int;
        self.creationDate = NSDate(timeIntervalSince1970: fromDictionary["creationDate"] as! NSTimeInterval)
        self.rawAcceleration = RawAcceleration(fromDictionary: fromDictionary["rawAccelerometer"] as! Dictionary<String, AnyObject>)
        self.linearAcceleration = LinearAcceleration(fromDictionary: fromDictionary["linearAcceleration"] as! Dictionary<String, AnyObject>)
    }
}

func ==(lhs: TestData, rhs: TestData) -> Bool {
    return lhs.id == rhs.id
}