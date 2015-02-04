//
//  Quaternion.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 18.01.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

struct Quaternion: Equatable {
    let w:Double
    let x:Double
    let y:Double
    let z:Double
    
    func toDictionary() -> Dictionary<String, AnyObject> {
        return ["w": w, "x": x, "y": y, "z": z]
    }
    
    init(fromDictionary: Dictionary<String, AnyObject>) {
        self.w = fromDictionary["w"] as Double
        self.x = fromDictionary["x"] as Double
        self.y = fromDictionary["y"] as Double
        self.z = fromDictionary["z"] as Double
    }
    
    init(w: Double, x: Double, y: Double, z: Double) {
        self.w = w
        self.x = x
        self.y = y
        self.z = z
    }
}

func ==(lhs: Quaternion, rhs: Quaternion) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z && lhs.w == rhs.w
}
