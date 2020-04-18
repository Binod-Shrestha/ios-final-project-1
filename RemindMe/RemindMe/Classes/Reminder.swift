//
//  Reminder.swift
//  RemindMe
//
//  Created by sherwin gonsalves on 2020-03-14.
//  Copyright © 2020 BBQS. All rights reserved.
//



import UIKit

class Reminder: NSObject {

    
    var id: Int?
    var reminderName : String?
    var reminderDate : String?
    var notification : Notification?
    
    
    //Methos that is used to set the reminder details into the database
    init(row: Int, reminderName: String, reminderDate: String) {
        self.id = row
        self.reminderDate = reminderDate
        self.reminderName = reminderName

    }
    
    
    override init() {
        super.init()
    }
    
    
    

}
