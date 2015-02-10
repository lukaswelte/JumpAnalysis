//
//  Quaternion.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 18.01.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

struct Quaternion: Equatable {
    let w:Int
    let x:Int
    let y:Int
    let z:Int
    
    func toDictionary() -> Dictionary<String, AnyObject> {
        return ["w": w, "x": x, "y": y, "z": z]
    }
    
    init(fromDictionary: Dictionary<String, AnyObject>) {
        self.w = fromDictionary["w"] as! Int
        self.x = fromDictionary["x"] as! Int
        self.y = fromDictionary["y"] as! Int
        self.z = fromDictionary["z"] as! Int
    }
    
    init(w: Int, x: Int, y: Int, z: Int) {
        self.w = w
        self.x = x
        self.y = y
        self.z = z
    }
}

func ==(lhs: Quaternion, rhs: Quaternion) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z && lhs.w == rhs.w
}
