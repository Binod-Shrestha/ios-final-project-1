//
//  Task.swift
//  RemindMe
//
//  Created by Xcode User on 2020-03-14.
//  Copyright © 2020 BBQS. All rights reserved.
//

// ****** Brian to update *******

import UIKit

class Task: NSObject {
    var id : Int?
    var user_id : Int?
    var title : String?
    var status : Bool?
    var priority : Int?
    var taskDueDate : String?
    var daysInAdvance : Int?
    var note : Note?
    
    override init() {
        super.init()
    }
    
    init(user_id : Int, title : String, status: Bool, priority: Int, taskDueDate: String, daysInAdvance: Int, note: Note?) {
        self.user_id = user_id
        self.title = title
        self.status = status
        self.priority = priority
        self.taskDueDate = taskDueDate
        self.daysInAdvance = daysInAdvance
        self.note = note
    }
    
    init(row: Int, user_id : Int, title : String, status: Bool, priority: Int, taskDueDate: String, daysInAdvance: Int, note: Note?) {
        self.id = row
        self.user_id = user_id
        self.title = title
        self.status = status
        self.priority = priority
        self.taskDueDate = taskDueDate
        self.daysInAdvance = daysInAdvance
        self.note = note
    }
}
