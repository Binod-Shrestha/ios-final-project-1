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
    var title : String?
    
    init(row : Int, title : String) {
        self.id = row
        self.title = title
    }
}
