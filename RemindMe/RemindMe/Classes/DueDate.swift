//
//  DueDate.swift
//  RemindMe
//
//  Created by Xcode User on 2020-03-14.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit

class DueDate: NSObject {
    var name: String
    var category: [String]
    var priority: String
    var dueDate: Date
    
    
     init(name:String, category:[String], priority:String,dueDate:Date) {
        self.name = name
        self.category = category
        self.priority = priority
        self.dueDate = dueDate
        
    }

}
