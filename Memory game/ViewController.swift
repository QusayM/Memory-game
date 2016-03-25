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
    var letters = ["詩", "史", "弒", "時", "市", "是", "刺", "食", "好", "我", "你", "吗", "再", "见", "您", "贵", "里", "我", "喜", "慢", "詩", "史", "弒", "時", "市", "是", "刺", "食", "好", "我", "你", "吗", "再", "见", "您", "贵", "里", "我", "喜", "慢"]
    var cell_index = 0
    var count = 0
    var currentCell : NSIndexPath! = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroung.image = UIImage(named: "wallpaper_01221.jpg")
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "update", userInfo: nil, repeats: true)
        
        for var index = 39; index >= 0; --index {
            let random = Int(arc4random_uniform(UInt32(index)))
            print(random)
            let temp = letters[index]
            letters[index] = letters[random]
            letters[random] = temp
        }
        print(letters)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func update() {
        
        ++count
        timer_label.text = timeString(count)
    }
    
    func timeString(time:Int) -> String {
        let minutes = Int(time) / 60
        let seconds = time - minutes * 60
        return String(format:"%02i:%02i",minutes,Int(seconds))
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 8
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
        
        cell.letter?.text = letters[cell_index]
        cell.letter?.hidden = true
        cell_index++
        return cell
    }
    
    //    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    //        <#code#>
    //    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CollectionViewCell
        
        if(cell.letter?.hidden == true) {
            
            UIView.transitionWithView(cell, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: { () -> Void in
                }, completion: nil)
            cell.letter?.hidden = false
            
            
            if(self.currentCell == nil) {
                self.currentCell = indexPath
            }
            else {
                collectionView.userInteractionEnabled = false
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                    
                    sleep(3)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        
                        let previousCell = collectionView.cellForItemAtIndexPath(self.currentCell) as! CollectionViewCell
                        
                        if(previousCell.letter?.text != cell.letter?.text) {
                            cell.letter?.hidden = true
                            UIView.transitionWithView(cell, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: { () -> Void in
                                }, completion: nil)
                            previousCell.letter?.hidden = true
                            UIView.transitionWithView(previousCell, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: { () -> Void in
                                }, completion: nil)
                        }
                        
                        self.currentCell = nil
                        collectionView.userInteractionEnabled = true
                        
                        
                    })
                }
                
            }
        }
    }
    
}

