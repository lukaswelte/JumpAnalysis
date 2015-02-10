//
//  Vector.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 18.01.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

struct Vector<K: Equatable> : Equatable {
    let x:K
    let y:K
    let z:K
    
    func toDictionary() -> Dictionary<String, AnyObject> {
        let doubleX = self.x as! Int
        let doubleY = self.y as! Int
        let doubleZ = self.z as! Int
        
        let dictionary:Dictionary<String, AnyObject> = ["x":doubleX, "y":doubleY, "z":doubleZ]
        return dictionary
    }
    
    init(fromDictionary: Dictionary<String, AnyObject>) {
        self.x = fromDictionary["x"] as! K
        self.y = fromDictionary["y"] as! K
        self.z = fromDictionary["z"] as! K
    }
    
    init(x: K, y: K, z:K) {
        self.x = x
        self.y = y
        self.z = z
    }
}

func ==<K: Equatable>(lhs: Vector<K>, rhs: Vector<K>) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
}