//
//  AppDelegate.swift
//  RemindMe
//
//  Created by Xcode User on 2020-03-14.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit
import SQLite3

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var databaseName : String? = "RemindMe.db"
    var databasePath : String?
    var contacts : [Contact] = []
    
    func insertContactIntoDatabase(contact : Contact) -> Bool
    {
        var db : OpaquePointer? = nil
        var returnCode : Bool = true
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK
        {
            var insertStatement : OpaquePointer? = nil
            let insertStatementString : String = "insert into contacts values(NULL,?,?,?,?,?,?,?,?)"
            
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK{
                let nameStr = contact.name! as NSString
                let organizationStr = contact.organization! as NSString
                let titleStr = contact.title! as NSString
                let phoneStr = contact.phone! as NSString
                let emailStr = contact.email! as NSString
                let discordStr = contact.discord! as NSString
                let slackStr = contact.slack! as NSString
                let notesStr = contact.notes! as NSString
                sqlite3_bind_text(insertStatement, 1, nameStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 2, organizationStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 3, titleStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 4, phoneStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 4, emailStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 6, discordStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 7, slackStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 4, notesStr.utf8String, -1, nil)
                
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    let rowID = sqlite3_last_insert_rowid(db)
                    print("Successfully inserted row \(rowID)")
                }else{
                    print("Counld not insert row")
                    returnCode = false
                }
                sqlite3_finalize(insertStatement)
                
            }else{
                print("Insert statement could not be prepared")
                returnCode = false
            }
            sqlite3_close(db)
        }
        else
        {
            print("Unable to open database")
            returnCode = false
        }
        return returnCode
    }
    
    func readContactDataFromDatabase(){
        //prep
        contacts.removeAll()
        var db : OpaquePointer? = nil
        //action
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK
        {
            print("Successfully opened connection to database at \(self.databasePath ?? "Unknown")")
            
            var queryStatement : OpaquePointer? = nil
            let queryStatementString : String = "select * from contacts"
            
            print("Testing if SQLite is Ok....")
            
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                print("SQLite is ok.")
                
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    print(".........................")
                    print("Row data being stored....")
                    
                    let id : Int = Int(sqlite3_column_int(queryStatement, 0))
                    let cname = sqlite3_column_text(queryStatement, 1)
                    let corganization = sqlite3_column_text(queryStatement, 2)
                    let ctitle = sqlite3_column_text(queryStatement, 3)
                    let cphone = sqlite3_column_text(queryStatement, 4)
                    let cemail = sqlite3_column_text(queryStatement, 5)
                    let cdiscord = sqlite3_column_text(queryStatement, 6)
                    let cslack = sqlite3_column_text(queryStatement, 7)
                    let cnotes = sqlite3_column_text(queryStatement, 8)
                    
                    let name = String(cString: cname!)
                    let organization = String(cString: corganization!)
                    let title = String(cString: ctitle!)
                    let phone = String(cString: cphone!)
                    let email = String(cString: cemail!)
                    let discord = String(cString: cdiscord!)
                    let slack = String(cString: cslack!)
                    let notes = String(cString: cnotes!)
                    
                    
                    let contact : Contact = Contact.init()
                    contact.initWithData(theRow: id, theName: name, theOrganization: organization, theTitle: title, thePhone: phone, theEmail: email, theDiscord: discord, theSlack: slack, theNotes: notes)
                    contacts.append(contact)
                    print("Row data stored")
                    print(".........................")
                    print("Query result:" )
                    print("\(id) | \(name) | \(organization) | \(title) | \(phone) | \(email) | \(discord) | \(slack) | \(notes)")
                }
                sqlite3_finalize(queryStatement)
            }else{
                print("SQLite is not ok.")
                print("Select statement could not be prepared")
            }
            print("Closing DB connection...")
            sqlite3_close(db)
            
        }
        else{
            print("Unable to open database")
        }
        
        
    }
    
    func getContactDataFromDatabaseByID(int id: Int){
        //prep
        contacts.removeAll()
        var db : OpaquePointer? = nil
        //action
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK
        {
            print("Successfully opened connection to database at \(self.databasePath ?? "Unknown")")
            
            var queryStatement : OpaquePointer? = nil
            let queryStatementString : String = "select * from contacts WHERE id = ?)"
            
            print("Testing if SQLite is Ok....")
            
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                print("SQLite is ok.")
                
                sqlite3_bind_int(db, 1, Int32(id))
                
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    print(".........................")
                    print("Row data being stored....")
                    
                    let id : Int = Int(sqlite3_column_int(queryStatement, 0))
                    let cname = sqlite3_column_text(queryStatement, 1)
                    let corganization = sqlite3_column_text(queryStatement, 2)
                    let ctitle = sqlite3_column_text(queryStatement, 3)
                    let cphone = sqlite3_column_text(queryStatement, 4)
                    let cemail = sqlite3_column_text(queryStatement, 5)
                    let cdiscord = sqlite3_column_text(queryStatement, 6)
                    let cslack = sqlite3_column_text(queryStatement, 7)
                    let cnotes = sqlite3_column_text(queryStatement, 8)
                    
                    let name = String(cString: cname!)
                    let organization = String(cString: corganization!)
                    let title = String(cString: ctitle!)
                    let phone = String(cString: cphone!)
                    let email = String(cString: cemail!)
                    let discord = String(cString: cdiscord!)
                    let slack = String(cString: cslack!)
                    let notes = String(cString: cnotes!)
                    
                    
                    let contact : Contact = Contact.init()
                    contact.initWithData(theRow: id, theName: name, theOrganization: organization, theTitle: title, thePhone: phone, theEmail: email, theDiscord: discord, theSlack: slack, theNotes: notes)
                    contacts.append(contact)
                    print("Row data stored")
                    print(".........................")
                    print("Query result:" )
                    print("\(id) | \(name) | \(organization) | \(title) | \(phone) | \(email) | \(discord) | \(slack) | \(notes)")
                }
                sqlite3_finalize(queryStatement)
            }else{
                print("SQLite is not ok.")
                print("Select statement could not be prepared")
            }
            print("Closing DB connection...")
            sqlite3_close(db)
            
        }
        else{
            print("Unable to open database")
        }
        
    }
    func deleteContactDataFromDatabaseByID(int id: Int){
        
    }
    
    func checkAndCreateDatabase(){
        
        var success = false
        let fileManager = FileManager.default
        
        success = fileManager.fileExists(atPath: databasePath!)
        
        if success{
            print("Database exists...")
            return
        }
        print("Building Database from resources...")
        let databasePathFromApp = Bundle.main.resourcePath?.appending("/" + databaseName!)
        
        try? fileManager.copyItem(atPath: databasePathFromApp!, toPath: databasePath!)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDir = documentPaths[0]
        databasePath = documentsDir.appending("/" + databaseName!)
        
        checkAndCreateDatabase()
        //readContactDataFromDatabase()
        return true
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

