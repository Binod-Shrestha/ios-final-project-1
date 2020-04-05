//
//  DueDateViewController1.swift
//  RemindMe
//
//  Created by Xcode User on 2020-03-19.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit
import SQLite3

class DueDateViewController1: UIViewController ,EKCalendarItem{
    
    
    
    @IBAction func unwindToDueDateVC(sender:UIStoryboardSegue){
        
    }
//    var dueDate: DueDate!{
//        didSet{
//            self.txtfdEvents.text = dueDate.name
//            self.dpDate.text = dueDate.dueDate.add
//            self.pickerData = dueDate.category
//            self.scPriority = DueDateViewController1
//            self.
//        }
//    }
    
    var db: OpaquePointer?
    
    @IBOutlet weak var txtfdEvents: UITextField!
    
    
    @IBOutlet weak var pvCategory: UIPickerView!
    var pickerData: [String] = [String]()
    
    @IBOutlet weak var dpDate: UIDatePicker!
    
    @IBOutlet weak var scPriority: UISegmentedControl!
    
    @IBAction func saveDueDate(_ sender: Any) {
        
        let event = txtfdEvents.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        // let category = pvCategory
        
        
        //validating that values are not empty
        if(event?.isEmpty)!{
            txtfdEvents.layer.borderColor = UIColor.red.cgColor
            return
        }
        
        //        if(category?.)!{
        //            pvCategory.layer.borderColor = UIColor.red.cgColor
        //            return
        //        }
        
        //creating a statement
        var stmt: OpaquePointer?
        
        //the insert query
        let queryString = "INSERT INTO DueDate (event) VALUES (?)"
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //binding the parameters
        if sqlite3_bind_text(stmt, 1, event, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        //        if sqlite3_bind_int(stmt, 2, (powerRanking! as NSString).intValue) != SQLITE_OK{
        //            let errmsg = String(cString: sqlite3_errmsg(db)!)
        //            print("failure binding name: \(errmsg)")
        //            return
        //        }
        
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting hero: \(errmsg)")
            return
        }
        
        //emptying the textfields
        txtfdEvents.text=""
        //        textFieldPowerRanking.text=""
        
        
        //  readValues()
        
        //displaying a success message
        print("DueDate saved successfully")
    }
    
    func createReminder(){
        
        let reminder = EKReminder(eventStore: AppDelegate.eventStore!)
        
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Connect data:
        //self.picker.delegate = self
        // self.picker.dataSource = self
        pickerData = ["Assignment", "Exam", "Events", "General", "Celebration", "Medication"]
        
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("DueDate.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS DueDate (id INTEGER PRIMARY KEY AUTOINCREMENT, event TEXT)", nil, nil,nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        
        // Do any additional setup after loading the view.
    }

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


