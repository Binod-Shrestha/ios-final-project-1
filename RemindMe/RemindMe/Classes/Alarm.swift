//
//  Alarm.swift
//  RemindMe
//
//  Created by Xcode User on 2020-03-14.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit
import Foundation

class Alarm: NSObject {
    
    var id: Int?
    var name: String?
    var sound: String?
    var time: Date?
    var rpeat: Bool?
    
    func initWithData(theRow i: Int, theName n: String, theSound s: String, theTime t: Date, theRpeat r: Bool){
        
        id = i
        name = n
        sound = s
        time = t
        rpeat = r
        
    }
    
    
}
