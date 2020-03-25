//
//  User.swift
//  RemindMe
//
//  Created by Xcode User on 2020-03-14.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit

class User: NSObject {
    var id : Int?
    var email : String?
    
    init(row : Int, email : String) {
        self.id = row
        self.email = email
    }
}
