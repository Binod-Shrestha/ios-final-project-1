//
//  User.swift
//  RemindMe
//
//  Created by sherwin Gosalves on 2020-03-14.
//  Copyright © 2020 BBQS. All rights reserved.
//



import UIKit

class User: NSObject {
    
//Declaration of objects
    var id: Int?
    var email : String?
    var password : String?
    var name: String?
    var securityAnswer: String?
    var securityQuestion: Int?
    
    
    
    override init() {
        super.init()
    }
    
    
    //For the forget password
    init(email : String, password : String) {
        self.email = email
        self.password = password
    }
    
    init(row: Int, email: String, securityQuestion: Int, securityAnswer : String) {
        self.id = row
        self.email = email
        self.securityQuestion = securityQuestion
        self.securityAnswer = securityAnswer
    }
    //For Registration
    init(row : Int, email: String, password : String, name : String, securityQuestion :Int, securityAnswer : String)
    {
        self.id = row
        self.email = email
        self.password = password
        self.name = name
        self.securityAnswer = securityAnswer
        self.securityQuestion = securityQuestion
    }
}
