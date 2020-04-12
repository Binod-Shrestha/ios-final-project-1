//
//  DueDate.swift
//  RemindMe
//
//  Created by Xcode User on 2020-03-14.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit

class DueDate: NSObject {
    var id: Int?
    var userId : Int?
    var name: String?
    var category: String?
    var subCategory: String?
    var date: String?
    var priority: String?
    var note : Note?
    var reminder : Reminder?
    
    
    
    func initWithData(theRow i: Int, theUserId ui: Int, theName n: String, theCategory ct: String, theSubCategory sb: String, theDate d: String, thePriority p: String, theNote note: Note?, theReminder reminder: Reminder?)
    {
        id = i
        userId = ui
        name = n
        category = ct
        subCategory = sb
        date = d
        priority = p
        self.note = note
        self.reminder = reminder
    }
}
