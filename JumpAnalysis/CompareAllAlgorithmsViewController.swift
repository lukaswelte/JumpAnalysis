//
//  CompareAllAlgorithmsViewController.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 21.03.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import UIKit

class CompareAllAlgorithmsViewController : UIViewController {
    @IBOutlet weak var resultTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "All Algorithms"
        
        let testResults = AnalyzationCoordinator.sharedInstance.testRunAndCompareAlgorithms().sorted { (a, b) -> Bool in
            if a.averagePercentage == b.averagePercentage {
                return a.worstPercentage > b.worstPercentage
            }
            return a.averagePercentage > b.averagePercentage
        }
        
        self.resultTextView.text = "Algorithm Name, Best, Worst, Mean, StdDv \n"
        for result in testResults {
            let descriptionString: String = NSString(format: "%@, %.4f%%, %.4f%%, %.4f%%, %.4f%% \n", result.algorithm.name, result.bestPercentage*100, result.worstPercentage*100, result.averagePercentage*100, result.standardDeviation*100) as! String
            self.resultTextView.text = self.resultTextView.text + descriptionString
        }
    }
}
