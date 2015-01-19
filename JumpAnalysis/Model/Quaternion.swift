//
//  Quaternion.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 18.01.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

struct Quaternion {
    let w:Double
    let x:Double
    let y:Double
    let z:Double
    
    func toDictionary() -> Dictionary<String, JSON> {
        return ["w": JSON(w), "x":JSON(x), "y":JSON(y), "z":JSON(z)]
    }
}
