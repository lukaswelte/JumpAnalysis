//
//  ChartSeries.swift
//
//  Created by Giampaolo Bellavite on 07/11/14.
//  Copyright (c) 2014 Giampaolo Bellavite. All rights reserved.
//

import UIKit

/**
Represent a series to draw in the line chart. Each series is defined with a dataset and appareance settings.
*/
class ChartSeries {
    var data: Array<ChartPoint>
    var area: Bool = false
    var line: Bool = true
    var color: UIColor = ChartColors.blueColor() {
        didSet {
            colors = (above: color, below: color)
        }
    }
    var colors: (above: UIColor, below: UIColor) = (above: ChartColors.blueColor(), below: ChartColors.redColor())
    
    init(_ data: Array<Float>) {
        self.data = []
        for (x, y) in enumerate(data) {
            let point: ChartPoint = ChartPoint(x: Float(x), y: Float(y as NSNumber))
            self.data.append(point)
        }
    }
    
    init(data: Array<ChartPoint>) {
        self.data = data
    }
}

