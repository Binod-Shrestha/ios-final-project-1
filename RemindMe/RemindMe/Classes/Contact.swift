//
//  Contact.swift
//  RemindMe
//
//  Created by Brian Holmes on 2020-03-14.
//  Copyright © 2020 BBQS. All rights reserved.
//

// ****** Brian  to complete *****


import UIKit

class Contact: NSObject {
    
    var id : Int?
    var user : Int?
    var name : String?
    var organization : String?
    var title : String?
    var phone : String?
    var email : String?
    var discord : String?
    var slack : String?
    var notes : String?
    
    override init() {
        super.init()
    }
    
    init(theOwerUser u : Int, theName n : String, theOrganization o : String, theTitle t : String, thePhone p: String, theEmail e : String, theDiscord d : String, theSlack s : String, theNotes no : String) {
        self.user = u
        self.name = n
        self.organization = o
        self.title = t
        self.phone = p
        self.email = e
        self.discord = d
        self.slack = s
        self.notes = no
    }
    
    init(theRow i: Int, theOwerUser u : Int, theName n : String, theOrganization o : String, theTitle t : String, thePhone p: String, theEmail e : String, theDiscord d : String, theSlack s : String, theNotes no : String) {
        self.id = i
        self.user = u
        self.name = n
        self.organization = o
        self.title = t
        self.phone = p
        self.email = e
        self.discord = d
        self.slack = s
        self.notes = no
    }
    
    func initWithData(theRow i: Int, theOwerUser u : Int, theName n : String, theOrganization o : String, theTitle t : String, thePhone p: String, theEmail e : String, theDiscord d : String, theSlack s : String, theNotes no : String){
        
        id = i
        user = u
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
