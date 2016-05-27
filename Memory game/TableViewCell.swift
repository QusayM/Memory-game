//
//  TableViewCell.swift
//  Memory game
//
//  Created by admin on 4/17/16.
//  Copyright © 2016 Anya&Qusay. All rights reserved.
//

import UIKit


class TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var editBtn: UIButton!
    
    var imagePicker = UIImagePickerController()
    
    var id : Int = 0
    let IMAGE = "image"
    
    @IBAction func changeImage(sender: UIButton) {
        
        
    }
    
  }