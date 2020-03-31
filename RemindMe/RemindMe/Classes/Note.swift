//
//  Note.swift
//  RemindMe
//
//  Created by Xcode User on 2020-03-14.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit

class Note: NSObject {
    var id : Int?
    var content : String?
    var task_id : Int?
    var duedate_id : Int?
    var user_id : Int?
    
    override init() {
        super.init()
    }

    init(content: String, task_id: Int?, duedate_id: Int?, user_id: Int) {
        self.content = content
        self.task_id = task_id
        self.duedate_id = duedate_id
        self.user_id = user_id
    }
    
    init(row: Int, content: String, task_id: Int?, duedate_id: Int?, user_id: Int) {
        self.id = row
        self.content = content
        self.task_id = task_id
        self.duedate_id = duedate_id
        self.user_id = user_id
    }
}
