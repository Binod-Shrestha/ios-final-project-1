//
//  User.swift
//  RemindMe
//
//  Created by Xcode User on 2020-03-14.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit

class User: NSObject {
    var email : String = ""
    var password : String = ""
    var name: String = ""
    var confirmPassword: String = ""
    var postalCode:  String = ""
    var phoneNumber: String = ""
    var streetName: String = ""
    
    func inWithData(theEmail n : String , thePassword e : String)
    {
        email = n
        password = e
        
    }
  
}
