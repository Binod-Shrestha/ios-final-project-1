//
//  Contact.swift
//  RemindMe
//
//  Created by Xcode User on 2020-03-14.
//  Copyright © 2020 BBQS. All rights reserved.
//

// ****** Brian  to complete *****


import UIKit

class Contact: NSObject {
    
    var id : Int?
    var name : String?
    var organization : String?
    var title : String?
    var phone : String?
    var email : String?
    var discord : String?
    var slack : String?
    var notes : String?
    
    func initWithData(theRow i: Int, theName n : String, theOrganization o : String, theTitle t : String, thePhone p: String, theEmail e : String, theDiscord d : String, theSlack s : String, theNotes no : String){
        
        id = i
        name = n
        organization = o
        title = t
        phone = p
        email = e
        discord = d
        slack = s
        notes = no
        
    }
    
}
