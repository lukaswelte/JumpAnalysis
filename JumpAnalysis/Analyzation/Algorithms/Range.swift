//
//  Range.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 20.07.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import UIKit

class Range: VisualizationInformation {
    var color: UIColor
    var description: String
    let startTime: Int
    let endTime: Int
    
    required init(color: UIColor, description: String, startTime: Int, endTime: Int) {
        self.color = color
        self.description = description
        self.startTime = startTime
        self.endTime = endTime
    }
}
