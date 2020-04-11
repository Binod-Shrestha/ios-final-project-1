//
//  Alert.swift
//  RemindMe
//
//  Created by Brian Holmes on 2020-04-08.
//  Copyright © 2020 BBQS. All rights reserved.
//
import UIKit


class Alert: NSObject {
    //properties
    var alertID: Int?
    var name: String
    var time: Int
    
    //Initializer

    init(alertID: Int, name: String, time: Int)
    {
        self.alertID = alertID
        self.name = name
        self.time = time
        
        super.init()
    }
    
    init(name: String, time: Int)
    {
        self.alertID = nil
        self.name = name
        self.time = time
        
        super.init()
    }
    //Mark : Remove
//    override init()
//    {
//        self.alertID = nil
//        self.name = ""
//        self.time = 0
//
//        super.init()
//    }
}



/*
 
 import Foundation
 import UIKit
 import UserNotifications
 
 class Alert: NSObject, NSCoding {
 //properties
 var notification: UNNotificationRequest
 var name: String
 //********* var alertID: Int
 var time: NSDate
 
 //Archive paths for persisent data
 static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
 static let ArchiveURL = DocumentsDirectory.appendingPathComponent("alerts")
 
 //enum for property keys
 struct PropertyKey {
 static let nameKey = "name"
 static let timeKey = "time"
 static let notificationKey = "notification"
 }
 
 //Initializer
 init(name: String, time: NSDate, notification: UNNotificationRequest)
 {
 self.name = name
 self.time = time
 self.notification = notification
 
 super.init()
 }
 
 // Destructor
 //    deinit{
 //        // cancel notification
 //        UIApplication.shared.cancelLocalNotification(self.notification)
 //    }
 
 
 
 // NSCoding
 func encode(with aCoder: NSCoder) {
 aCoder.encode(name, forKey: PropertyKey.nameKey)
 aCoder.encode(time, forKey: PropertyKey.timeKey)
 aCoder.encode(notification, forKey: PropertyKey.notificationKey)
 }
 
 required convenience init(coder aDecoder: NSCoder){
 let name = aDecoder.decodeObject(forKey: PropertyKey.nameKey) as! String
 let time = aDecoder.decodeObject(forKey: PropertyKey.timeKey) as! NSDate
 let notification = aDecoder.decodeObject(forKey: PropertyKey.notificationKey) as! UNNotificationRequest
 
 self.init(name: name, time: time, notification: notification)
 
 }
 
 
 }
 */
*/

