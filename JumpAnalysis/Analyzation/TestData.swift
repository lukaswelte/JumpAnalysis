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
        self.id = fromDictionary["id"] as! Int;
        self.isLeftFoot = fromDictionary["leftFoot"] as! Bool
        self.jumperName = fromDictionary["name"] as! String
        self.jumperWeightInKg = fromDictionary["weightInKg"] as! Double
        self.jumperHeightInCm = fromDictionary["heightInMeter"] as! Int
        self.jumpDurationInMs = fromDictionary["jumpDurationInMs"] as! Int
        self.jumpDistanceInCm = fromDictionary["jumpDistanceInCm"] as! Int
        self.sensorData = (fromDictionary["sensorData"] as! Array).map{dict in SensorData(fromDictionary: dict)}
    }
}

func ==(lhs: TestData, rhs: TestData) -> Bool {
    return lhs.id == rhs.id
}