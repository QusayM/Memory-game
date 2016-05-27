//
//  HighScoresViewController.swift
//  Memory game
//
//  Created by Perry on 13/05/2016.
//  Copyright © 2016 Anya&Qusay. All rights reserved.
//

import UIKit


class HighScoresViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    var scores : [Score!]! = nil
    let SCORES = "scores"
    var currentIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scoresData = NSUserDefaults.standardUserDefaults().objectForKey(SCORES) as? NSData
        
        if scoresData != nil {
            scores = NSKeyedUnarchiver.unarchiveObjectWithData(scoresData!) as? [Score]
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath)
        cell.textLabel?.text = scores[indexPath.row].name + " :";
        cell.detailTextLabel?.text = "\(scores[indexPath.row].value)"
        return cell
    }
    
}