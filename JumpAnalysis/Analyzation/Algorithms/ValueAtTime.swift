//
//  ValueAtTime.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 20.07.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import UIKit

class ValueAtTime: VisualizationInformation {
    var color: UIColor
    var description: String
    let value: Double
    let timestamp: Int
    
    required init(color: UIColor, description: String, value: Double, timestamp: Int) {
        self.color = color
        self.description = description
        self.value = value
        self.timestamp = timestamp
    }
}