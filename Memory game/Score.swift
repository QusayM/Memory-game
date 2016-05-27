//
//  Score.swift
//  Memory game
//
//  Created by Perry on 13/05/2016.
//  Copyright © 2016 Anya&Qusay. All rights reserved.
//

import Foundation

class Score : NSObject {
    var name : String
    var value : Int
    
    
    init(name: String, value: Int) {
        self.name = name
        self.value = value
    }
    
    required init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.value = aDecoder.decodeIntegerForKey("value")
    }
    
    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeInteger(self.value, forKey: "value")
    }
    
}