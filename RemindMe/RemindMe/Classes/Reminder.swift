//
//  Reminder.swift
//  RemindMe
//
//  Created by Xcode User on 2020-03-14.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit

class Reminder: NSObject {

    
    var id: Int?
    var reminderName : String?
    var reminderDate : String?

    
    var notification : Notification?
    
    init(row: Int, reminderName: String, reminderDate: String) {
        self.id = row
        self.reminderDate = reminderDate
        self.reminderName = reminderName

    }
    
    
  /*  init(row: Int, reminderName: String, reminderDate: String, notification :Notification, alarm :Alarm) {
        self.id = row
        self.reminderDate = reminderDate
        self.reminderName = reminderName
      self.notification = notification
     self.alarm  = alarm
    }
    */
    override init() {
        super.init()
    }
    
    
    

}
