//
//  Vector.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 18.01.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

struct Vector<K: FloatLiteralConvertible> {
    let x:K
    let y:K
    let z:K
    
    func toDictionary() -> Dictionary<String, AnyObject> {
        let doubleX = self.x as Double
        let doubleY = self.y as Double
        let doubleZ = self.z as Double
        
        let dictionary:Dictionary<String, AnyObject> = ["x":doubleX, "y":doubleY, "z":doubleZ]
        return dictionary
    }
}