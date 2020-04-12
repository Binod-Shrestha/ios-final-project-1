//
//  Notification.swift
//  RemindMe
//
//  Created by Xcode User on 2020-03-14.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit

class Notification: NSObject {
    var id: Int?
    var status: String?
    var date: String?
    
    func initWithData(theRow i: Int, theStatus s: String, theDate d: String)
    {
        id = i
        status = s
        date = d
        
    }

}
