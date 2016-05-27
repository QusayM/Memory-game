//
//  MainMenuViewController.swift
//  Memory game
//
//  Created by admin on 4/17/16.
//  Copyright © 2016 Anya&Qusay. All rights reserved.
//

import UIKit


class MainMenuViewController: UIViewController {
    
    @IBOutlet weak var logo: UIImageView!
    
    let LAUNCHED_BEFORE = "launchedBefore"
    let HIGHEST_SCORE = "highestScore"
    let IMAGE = "image"
    let DEFAULT_IMAGE = "default_image"
    let SCORES = "scores"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstRunSetup()
        logo.image = UIImage(named: "playmatch-300x300.png")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func firstRunSetup() {
        
        let launchedBefore = NSUserDefaults.standardUserDefaults().boolForKey(LAUNCHED_BEFORE)
        if !launchedBefore  {
            print("First launch, setting NSUserDefault.")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: LAUNCHED_BEFORE)
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: HIGHEST_SCORE)
            
            var images = [UIImage(named: "Beaver-48.png"), UIImage(named: "Bumblebee-48.png"), UIImage(named: "Butterfly-48.png"), UIImage(named: "Dog-48.png"), UIImage(named: "Dolphin-48.png"), UIImage(named: "Fish-48.png"), UIImage(named: "Kangaroo-48.png"), UIImage(named: "Pig-48.png"), UIImage(named: "Sheep-48.png"), UIImage(named: "Turtle-48.png")]
            
            for i in 0 ..< images.count  {
                NSUserDefaults.standardUserDefaults().setObject(UIImagePNGRepresentation(images[i]!), forKey: IMAGE + "\((i + 1))")
                NSUserDefaults.standardUserDefaults().setObject(UIImagePNGRepresentation(images[i]!), forKey: DEFAULT_IMAGE + "\((i + 1))")
            }
            
            let scores = [Score!]()
            let scoresData = NSKeyedArchiver.archivedDataWithRootObject(scores)
            NSUserDefaults.standardUserDefaults().setObject(scoresData, forKey: self.SCORES)
            
        }
    }
}


