//
//  ViewController.swift
//  Memory game
//
//  Created by admin on 3/6/16.
//  Copyright © 2016 Anya&Qusay. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var backgroung: UIImageView!
    @IBOutlet weak var timer_label: UILabel!
    @IBOutlet weak var score_label: UILabel!
    
    let IMAGE = "image"
    let SCORES = "scores"
    var images = [UIImage?](count:0, repeatedValue: nil)
    var cell_index = 0
    var count = 0
    var game : Game = Game()
    var currentCell : NSIndexPath! = nil
    var myTimer : NSTimer! = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //backgroung.image = UIImage(named: "wallpaper_01221.jpg")
        myTimer =  NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true)
        
        for i in 0 ..< 10 {
            let imageData =  NSUserDefaults.standardUserDefaults().objectForKey(IMAGE + "\((i + 1))") as! NSData
            let image = UIImage(data: imageData)!
            images.insert(image, atIndex: i)
            images.insert(image, atIndex: (images.count/2 + i))
            
        }
        
        for var index = images.count - 1; index >= 0; index -= 1 {
            let random = Int(arc4random_uniform(UInt32(index)))
            print(random)
            let temp = images[index]
            images[index] = images[random]
            images[random] = temp
        }
        print(images)
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.score_label.text = String(format:"%02i",self.game.score)
        //getPlayerName()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func update() {
        
        count += 1
        timer_label.text = timeString(count)
    }
    
    func timeString(time:Int) -> String {
        let minutes = Int(time) / 60
        let seconds = time - minutes * 60
        return String(format:"%02i:%02i",minutes,Int(seconds))
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return game.rows
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return game.cols
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
        
        cell.image?.image = images[cell_index]
        cell.image?.hidden = true
        cell_index += 1
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let size = (collectionView.bounds.width - 10*5) / 5
        return CGSize(width: size, height: size)
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CollectionViewCell
        
        if(cell.image?.hidden == true) {
            
            UIView.transitionWithView(cell, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: { () -> Void in
                }, completion: nil)
            cell.image?.hidden = false
            
            
            if(self.currentCell == nil) {
                self.currentCell = indexPath
            }
            else {
                collectionView.userInteractionEnabled = false
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                    
                    sleep(3)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        
                        let previousCell = collectionView.cellForItemAtIndexPath(self.currentCell) as! CollectionViewCell
                        
                        if(previousCell.image?.image != cell.image?.image) {
                            cell.image?.hidden = true
                            UIView.transitionWithView(cell, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: { () -> Void in
                                }, completion: nil)
                            previousCell.image?.hidden = true
                            UIView.transitionWithView(previousCell, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: { () -> Void in
                                }, completion: nil)
                            
                            self.game.score -= 1
                            self.score_label.text = String(format:"%02i",self.game.score)
                        }
                        
                        else {
                            self.game.cardsLeft -= 1
                            
                            
                            //if(self.cardsLeft == 0) {
                                self.myTimer.invalidate()
                                self.getPlayerName()
                            //}
                        }
                        
                        self.currentCell = nil
                        collectionView.userInteractionEnabled = true
                        
                        
                    })
                }
                
            }
        }
    }
    
    private func getPlayerName() {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Game over", message: "Finished after: \(self.timer_label.text!)\nPlease Enter your name", preferredStyle: .Alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.text = "Your name"
        })
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            
            //initialize the score object
            let newScore = Score(name: textField.text!, value: self.game.score)
            
            let scoresData = NSUserDefaults.standardUserDefaults().objectForKey(self.SCORES) as? NSData
            
            if scoresData != nil {
                var scores_arr = NSKeyedUnarchiver.unarchiveObjectWithData(scoresData!) as? [Score]

                scores_arr!.append(newScore)
                
                scores_arr!.sortInPlace{ (element1, element2) -> Bool in
                    return element1.value > element2.value
                }
                
                let scoresData = NSKeyedArchiver.archivedDataWithRootObject(scores_arr!)
                NSUserDefaults.standardUserDefaults().setObject(scoresData, forKey: self.SCORES)

            }
            
            self.navigationController?.popViewControllerAnimated(true)
            
        }))
        
        // 4. Present the alert.
        self.presentViewController(alert, animated: true, completion: nil)

    }
}

