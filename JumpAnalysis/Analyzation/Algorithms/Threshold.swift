//
//  Threshold.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 20.07.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import UIKit

class Threshold: VisualizationInformation {
    var color: UIColor
    var description: String
    let value: Double
    
    required init(color: UIColor, description: String, value: Double) {
        self.color = color
        self.description = description
        self.value = value
    }
}