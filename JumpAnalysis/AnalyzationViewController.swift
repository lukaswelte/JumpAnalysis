//
//  FirstViewController.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 18.01.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import UIKit

class AnalyzationViewController: UITableViewController {

    let analyzationCoordinator = AnalyzationCoordinator.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func compareAllAndPrintResults(sender: AnyObject) {
        analyzationCoordinator.testRunAndCompareAlgorithms()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return analyzationCoordinator.algorithms.count+1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "AlgorithmCell")
        let index = indexPath.row
        if index==0 {
            cell.textLabel?.text = "Compare all Algorithms"
        } else {
            cell.textLabel?.text = analyzationCoordinator.algorithms[indexPath.row-1].name
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            self.performSegueWithIdentifier("showCompareAlgorithms", sender: self)
        } else {
            self.performSegueWithIdentifier("showAlgorithmDetail", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showAlgorithmDetail" {
            
            // configure AlgorithmDetailViewController
            let algorithmViewController: AlgorithmDetailViewController = segue.destinationViewController as! AlgorithmDetailViewController
            if let selectedRowIndexPath = tableView.indexPathForSelectedRow() {
                if selectedRowIndexPath.row > 0 {
                    let algorithm = analyzationCoordinator.algorithms[selectedRowIndexPath.row-1]
                    algorithmViewController.algorithm = algorithm
                }
            }
        }
    }
}

