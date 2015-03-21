//
//  AlgorithmDetailViewController.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 21.03.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import UIKit

class AlgorithmDetailViewController : UIViewController, UITableViewDataSource {
    var algorithm: AlgorithmProtocol = FakeAlgorithm()
    var analyzationResults : [AnalyzationResult] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var distributionGraph: Chart!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = algorithm.name
        
        let algorithmResult = AnalyzationCoordinator.sharedInstance.testSingleAlgorithm(algorithm)
        self.analyzationResults = algorithmResult.analyzationResults
        self.tableView.dataSource = self
        self.distributionGraph.maxY = 1
        self.distributionGraph.areaAlphaComponent = 0.8
        let chartSeries : ChartSeries = ChartSeries(analyzationResults.map {s in Float(s.precision)})
        self.distributionGraph.addSeries(chartSeries)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return analyzationResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "TestDataCell")
        let analyzationResult = analyzationResults[indexPath.row]
        cell.textLabel?.text = "TestData \(analyzationResult.testData.id)"
        let detailText = NSString(format: "Result: %.2f, %.2f%%", analyzationResult.computedResult, analyzationResult.precision*100)
        cell.detailTextLabel?.text = detailText as String
        return cell
    }
}