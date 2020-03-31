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
    
    var securityQuestions = ["What is your mothers name?", "What is your best friend's name?", "Which school do you study at?"]
    var currentUser : User? = nil
    
    //MARK: Database functions for Users
    func resetPassword(user: User, newPassword : String) -> Bool {
        var db : OpaquePointer? = nil
        var returnCode : Bool = true
        
        if sqlite3_open(self.databasePath!, &db) == SQLITE_OK {
            
            var updateStatement : OpaquePointer? = nil
            var updateStatementString : String = "update Users set Password = ? where ID = ?"
            
            if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
                
                let cPassword = newPassword as NSString
                
                sqlite3_bind_text(updateStatement, 1, cPassword.utf8String, -1, nil)
                sqlite3_bind_int(updateStatement, 2, Int32(user.id!))
                
                if sqlite3_step(updateStatement) == SQLITE_DONE {
                    print("Updated password of user \(user.id) | \(user.email)")
                } else {
                    print("Update user password failed")
                    returnCode = false
                }
                
                sqlite3_finalize(updateStatement)
            } else {
                print("Could not prepare update user statement")
                returnCode = false
            }
            
            sqlite3_close(db)
        } else {
            print("Could not open db")
            returnCode = false
        }
        
        return returnCode
    }
    
    func getUserByEmail (email : String) -> User? {
       // var user : User = User()
       var user : User? = nil
        
        var db : OpaquePointer? = nil
        
        if sqlite3_open(self.databasePath!, &db) == SQLITE_OK {
            
            var findUserStatement : OpaquePointer? = nil
            var findUserStatementString : String = "select Id, Email, Question, Answer from Users where Email = ?"
            
            if sqlite3_prepare_v2(db, findUserStatementString, -1, &findUserStatement, nil) == SQLITE_OK {
                
                let cEmail = email as NSString
                
                sqlite3_bind_text(findUserStatement, 1, cEmail.utf8String, -1, nil)
                
                if sqlite3_step(findUserStatement) == SQLITE_ROW {
                    
                    let id : Int = Int(sqlite3_column_int(findUserStatement, 0))
                    let cEmail = sqlite3_column_text(findUserStatement, 1)
                    let question = Int(sqlite3_column_int(findUserStatement, 2))
                    let cAnswer = sqlite3_column_text(findUserStatement, 3)
                    
                    let email = String(cString: cEmail!)
                    let answer = String(cString: cAnswer!)

                    user = User(row: id, email: email, securityQuestion: question, securityAnswer: answer)

                } else {
                    print("Cannot find email: \(email)")
                }
                
                sqlite3_finalize(findUserStatement)
            } else {
                print("Could not prepare find user by email statement")
            }
            
            sqlite3_close(db)
        } else {
            print("Could not open database")
        }
        
        return user
    }
    
    func logOut() {
        currentUser = nil
    }
    
    func loginVerification(user : User) -> Bool {
        var db : OpaquePointer? = nil
        var returnCode : Bool = true
        
        if (sqlite3_open(self.databasePath, &db) == SQLITE_OK) {
            var checkStatement : OpaquePointer? = nil
            let checkStatementString = "select * from users where Email = ? and Password = ?"
            
            
            if(sqlite3_prepare_v2(db, checkStatementString, -1, &checkStatement, nil) == SQLITE_OK) {
                let emailStr = user.email! as NSString
                let passwordStr = user.password! as NSString
                
                sqlite3_bind_text(checkStatement, 1, emailStr.utf8String, -1, nil);
                sqlite3_bind_text(checkStatement, 2, passwordStr.utf8String, -1, nil);
                
                if (sqlite3_step(checkStatement) == SQLITE_ROW) {
                    
                    let id : Int = Int(sqlite3_column_int(checkStatement, 0))
                    let cName = sqlite3_column_text(checkStatement, 1)
                    let cEmail = sqlite3_column_text(checkStatement, 2)
                    let cPassword = sqlite3_column_text(checkStatement, 3)
                    let question = Int(sqlite3_column_int(checkStatement, 4))
                    let cAnswer = sqlite3_column_text(checkStatement, 5)
                    
                    let name = String(cString: cName!)
                    let email = String(cString: cEmail!)
                    let password = String(cString: cPassword!)
                    let answer = String(cString: cAnswer!)
                    
                    currentUser = User(row: id, email: email, password: password, name: name, securityQuestion: question, securityAnswer: answer)
                    
                } else {
                    NSLog("Successful failed")
                    returnCode = false
                }
                
                sqlite3_finalize(checkStatement)
            } else {
                print("Could not prepare login statement")
                returnCode = false
            }
            
            sqlite3_close(db)
        } else {
            print("Could not open the database")
            returnCode = false
        }
        
        return  returnCode
    }
    
    func signUp(user : User) -> Bool
    {
        var db : OpaquePointer? = nil
        var returnCode : Bool = true
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK
        {
            var insertStatement : OpaquePointer? = nil
            let insertStatementString = "insert into users values(NULL,?,?,?,?,?)"
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK
            {
                let nameStr = user.name! as NSString
                let emailStr = user.email! as NSString
                let passwordStr = user.password! as NSString
                let securityAnswerStr = user.securityAnswer! as NSString
                
                sqlite3_bind_text(insertStatement, 1, nameStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 2, emailStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 3, passwordStr.utf8String, -1, nil)
                sqlite3_bind_int(insertStatement, 4, Int32(user.securityQuestion!))
                sqlite3_bind_text(insertStatement, 5, securityAnswerStr.utf8String, -1, nil)
                
                if sqlite3_step(insertStatement) == SQLITE_DONE{
                    let rowId = sqlite3_last_insert_rowid(db)
                    print("Succeful inserted \(rowId)")
                }
                else{
                    print("Could not insert user")
                    returnCode = false
                }
                sqlite3_finalize(insertStatement)
            }
            else {print("Could not prepare insert user statement")
                returnCode = false
            }
            sqlite3_close(db)
        }
        else {
            print("Unable to open Db")
            returnCode = false
        }
        return returnCode
    }
    
    func checkAndCreateDatabase()
    {
        var success = false
        let fileManager = FileManager.default
        
        success = fileManager.fileExists(atPath: databasePath!)
        
        if success {
            return
            
        }
        let databasePathFromApp = Bundle.main.resourcePath?.appending("/" + databaseName!)
        
        try?fileManager.copyItem(atPath: databasePathFromApp!, toPath: databasePath!)
        
        return
    }
    
    //MARK: Default functions
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        let documentsDir = documentPaths[0]
        databasePath = documentsDir.appending("/" + databaseName!)
        
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

