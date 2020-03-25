//
//  AppDelegate.swift
//  RemindMe
//
//  Created by Xcode User on 2020-03-14.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var databaseName : String? = "RemindMe.db"
    var databasePath : String?
    
    var user : User?
    var task : Task?
    var note : Note?
    
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

