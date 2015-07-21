//
//  Peak.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 20.07.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import UIKit

class Peak: VisualizationInformation {
    var color: UIColor
    var description: String
    let timestamp: Int
    
    required init(color: UIColor, description: String, timestamp: Int) {
        self.color = color
        self.description = description
        self.timestamp = timestamp
    }
}
