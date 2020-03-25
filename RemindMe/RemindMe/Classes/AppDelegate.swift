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
    
    var user : User?
    var task : Task?
    var note : Note?
    
    func deleteNote(id: Int) -> Bool {
        var db : OpaquePointer? = nil
        var returnCode = false
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            var deleteStatement : OpaquePointer? = nil
            var deleteQuery: String = "delete from Notes where Id = ?"
            
            if sqlite3_prepare_v2(db, deleteQuery, -1, &deleteStatement, nil) == SQLITE_OK {
                
                sqlite3_bind_int(deleteStatement, 1, Int32(id))
                
                if sqlite3_step(deleteStatement) == SQLITE_DONE {
                    returnCode = true
                    print("Successfully deleted note id: \(id)")
                } else {
                    print("Could not delete the note id:\(id)")
                }
                sqlite3_finalize(deleteStatement)
            } else {
                print("Could not prepare delete note statement")
            }
            sqlite3_close(db)
        } else {
            print("Could not open the database")
        }
        
        return returnCode
    }
    
    func insertNote(note: Note) -> Bool {
        var db : OpaquePointer? = nil
        var returnCode : Bool = false
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            var insertStatement :OpaquePointer? = nil
            var insertQuery : String = "insert into Notes values(NULL, ?, ?, ?, ?)"
            
            if sqlite3_prepare_v2(db, insertQuery, -1, &insertStatement, nil) == SQLITE_OK {
                let cContent = note.content! as NSString
                
                sqlite3_bind_text(insertStatement, 1, cContent.utf8String, -1, nil)
                if note.task_id == nil {
                    sqlite3_bind_null(insertStatement, 2)
                } else {
                    sqlite3_bind_int(insertStatement, 2, Int32(note.task_id!))
                }
                if note.duedate_id == nil {
                    sqlite3_bind_null(insertStatement, 3)
                } else {
                    sqlite3_bind_int(insertStatement, 3, Int32(note.duedate_id!))
                }
                sqlite3_bind_int(insertStatement, 4, Int32(note.user_id!))
                
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    let rowID = sqlite3_last_insert_rowid(db)
                    print("Successfully inserted note into id: \(rowID)")
                    returnCode = true
                } else {
                    print("Could not insert note")
                }
                sqlite3_finalize(insertStatement)
            } else {
                print("Could not prepare insert note statement")
            }
            sqlite3_close(db)
        } else {
            print("Could not open the database")
        }
        
        return returnCode
    }
    
    func checkAndCreateDatabase() {
        var success = false
        
        // Access to FileManager
        let fileManager = FileManager.default
        
        // Check if the database already exists
        success = fileManager.fileExists(atPath: databasePath!)
        
        if success {
            return
        }
        
        // If the database doesn't exist, copy the database to app's document folder by looking for the app location on the device
        let databasePathFromApp = Bundle.main.resourcePath?.appending("/" + databaseName!)
        
        // try for error handling
        try?fileManager.copyItem(atPath: databasePathFromApp!, toPath: databasePath!)
        
        return
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDir = documentPaths[0]
        
        // Set the path of database
        databasePath = documentDir.appending("/" + databaseName!)
        
        checkAndCreateDatabase()
        
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

