//
//  AppDelegate.swift
//  RemindMe
//
//  Created by Xcode User on 2020-03-14.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit
import SQLite3
import UserNotifications
import EventKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    //MARK: ========================= DECLARATIONS ================================
    var window: UIWindow?

    var databaseName : String? = "RemindMe.db"
    var databasePath : String?
    var currentUser : User? = nil
    var currentTask : Task? = nil
    var currentDueDate : DueDate? = nil

    var curentReminder : Reminder? = nil
    
    var calendars: [EKCalendar] =  [EKCalendar]()


//    var currentAlert : Alert? = nil
//    var newAlert : Alert? = nil

    var currentContact : Contact? = nil
    var updateContact : Bool = false

    var currentNotification: Notification? = nil
   // var calendars: [EKCalendar] =  [EKCalendar]()

    var securityQuestions = ["What is your mothers name?", "What is your best friend's name?", "Which school do you study at?"]

    var contacts : [Contact] = []
    var duedates : [DueDate] = []
    var notifications:[Notification] = []
    var notification : Notification = Notification()
    
    var reminders : [Reminder] = []
    var eventStore : EKEventStore? = nil
    
    var signIncallback: (()->())?
    
    //MARK: =================END OF DECLARATIONS ================================

    //MARK: Database functions for DueDates
    //delete method
    func deleteDueDate(id: Int) -> Bool {
        var db : OpaquePointer? = nil
        var returnCode = false
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            var deleteStatement : OpaquePointer? = nil
            var deleteQuery : String = "delete from DueDates where ID = ?"
            
            if sqlite3_prepare_v2(db, deleteQuery, -1, &deleteStatement, nil) == SQLITE_OK {
                
                sqlite3_bind_int(deleteStatement, 1, Int32(id))
                
                if sqlite3_step(deleteStatement) == SQLITE_DONE {
                    print("Deleted duedate \(id)")
                    returnCode = true
                } else {
                    print("Could not delete duedate \(id)")
                }
                
                sqlite3_finalize(deleteStatement)
            } else {
                print("Could not prepare delete duedate statement")
            }
            
            sqlite3_close(db)
        } else {
            print("Could not open database")
        }
        
        return returnCode
    }
    
    //update function
    func updateDueDateData(duedate : DueDate) -> Bool {
        var db : OpaquePointer? = nil
        var returnCode = true
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK
        {
            var updateStatement : OpaquePointer? = nil
            let updateStatementString = "UPDATE DueDates SET Name=?, Category=?, SubCategory=?, SelectedDate=?, Priority=? WHERE ID=?"
            if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK
            {
                
                let cName = duedate.name! as NSString
                let cCategory = duedate.category! as NSString
                let cSubCategory = duedate.subCategory! as NSString
                let cDate = duedate.date! as NSString
                let cPriority = duedate.priority! as NSString
                
                //TODO: Update Note and Reminder here
                
                sqlite3_bind_text(updateStatement, 1, cName.utf8String, -1, nil)
                sqlite3_bind_text(updateStatement, 2, cCategory.utf8String, -1, nil)
                sqlite3_bind_text(updateStatement, 3, cSubCategory.utf8String, -1, nil)
                sqlite3_bind_text(updateStatement, 4, cDate.utf8String, -1, nil)
                sqlite3_bind_text(updateStatement, 5, cPriority.utf8String, -1, nil)
                sqlite3_bind_int(updateStatement, 6, Int32(duedate.id!))
                
                if sqlite3_step(updateStatement) == SQLITE_DONE
                {
                    print("Successfully updated row.")
                } else {
                    print("Could not update row.")
                    returnCode = false
                }
            } else {
                print("UPDATE statement could not be prepared")
                returnCode = false
            }
            sqlite3_finalize(updateStatement)
            
        } else {
            print("Could not open database")
            returnCode = false
        }
        
        return returnCode
    }
    
    func getDueDatesByUserId(userId : Int)
    {
        duedates.removeAll()
        var db : OpaquePointer? = nil
        
        if sqlite3_open(self.databasePath, &db)==SQLITE_OK
        {
            print("Successfully Opened database \(String(describing: self.databasePath))")
            var queryStatement :OpaquePointer? = nil
            let queryStatementString : String = "select * from DueDates where UserId = ?"
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK
            {
                sqlite3_bind_int(queryStatement, 1, Int32(userId))
                
                while sqlite3_step(queryStatement) == SQLITE_ROW
                {
                    let id : Int = Int(sqlite3_column_int(queryStatement, 0))
                    let userId : Int = Int(sqlite3_column_int(queryStatement, 1))
                    let cname = sqlite3_column_text(queryStatement, 2)
                    let ccategory = sqlite3_column_text(queryStatement, 3)
                    let csubCategory = sqlite3_column_text(queryStatement, 4)
                    let cdate = sqlite3_column_text(queryStatement, 5)
                    let cpriority = sqlite3_column_text(queryStatement, 6)
                    let alert : Int = Int(sqlite3_column_int(queryStatement, 7))
                    
                    let name = String(cString: cname!)
                    let category = String(cString: ccategory!)
                    let subCategory = String(cString: csubCategory!)
                    let date = String(cString: cdate!)
                    let priority = String(cString: cpriority!)
                    
                    //TODO: Call getNoteByDueDateId
                    // Call getNoteByID here
                    let note : Note? = nil
                    
                    //TODO: Call getReminderByDueDateId
                    // Call getReminderByDueDateId here
                    let reminder : Reminder? = nil
                    
                    let data : DueDate = DueDate.init()
                    data.initWithData(theRow: id, theUserId: userId, theName: name, theCategory: category, theSubCategory: subCategory, theDate: date, thePriority: priority, theAlert: alert)
                    duedates.append(data)
                    print("Query Result")
                    print("\(id) | \(userId) | \(name) | \(category) | \(subCategory) | \(date) | \(priority)")
                }
                
                sqlite3_finalize(queryStatement)
            }
            else {
                print("Select Couldnt be prepared")
            }
            sqlite3_close(db)
        }
        else
        {
            print("Unable to open Database")
        }
    }
    
    func readDataFromDueDates()
    {
        duedates.removeAll()
        var db : OpaquePointer? = nil
        
        if sqlite3_open(self.databasePath, &db)==SQLITE_OK
        {
            print("Successfully Opened database \(self.databasePath)")
            var queryStatement :OpaquePointer? = nil
            let queryStatementString : String = "select * from DueDates"
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK
            {
                while sqlite3_step(queryStatement) == SQLITE_ROW
                {
                    let id : Int = Int(sqlite3_column_int(queryStatement, 0))
                    let userId : Int = Int(sqlite3_column_int(queryStatement, 1))
                    let cname = sqlite3_column_text(queryStatement, 2)
                    let ccategory = sqlite3_column_text(queryStatement, 3)
                    let csubCategory = sqlite3_column_text(queryStatement, 4)
                    let cdate = sqlite3_column_text(queryStatement, 5)
                    let cpriority = sqlite3_column_text(queryStatement, 6)
                    let alertID : Int = Int(sqlite3_column_int(queryStatement, 7))
                    
                    let name = String(cString: cname!)
                    let category = String(cString: ccategory!)
                    let subCategory = String(cString: csubCategory!)
                    let date = String(cString: cdate!)
                    let priority = String(cString: cpriority!)
                    
                    let data : DueDate = DueDate.init()
                    data.initWithData(theRow: id, theUserId: userId, theName: name, theCategory: category, theSubCategory: subCategory, theDate: date, thePriority: priority,  theAlert: alertID)
                    
                    duedates.append(data)
                    print("Query Result")
                    print("\(id) | \(userId) | \(name) | \(category) | \(subCategory) | \(date) | \(priority)")
                }
                
                sqlite3_finalize(queryStatement)
            }
            else {
                print("Select Couldnt be prepared")
            }
            sqlite3_close(db)
        }
        else
        {
            print("Unable to open Database")
        }
    }
    
    func insertDueDateIntoDatabase(duedate : DueDate) -> Bool
    {
        var db : OpaquePointer? = nil
        var returnCode : Bool = true
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK
        {
            var insertStatement : OpaquePointer? = nil
            let insertStatementString = "insert into DueDates values(NULL,?,?,?,?,?,?,?)"
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK
            {
                
                let userId : Int = currentUser!.id!
                let nameStr = duedate.name! as NSString
                let categoryStr = duedate.category! as NSString
                let subCategoryStr = duedate.subCategory! as NSString
                let dateStr = duedate.date! as NSString
                let priorityStr = duedate.priority! as NSString
                let alertID : Int = notification.id ?? 99
                
                
                sqlite3_bind_int(insertStatement, 1, Int32(userId))
                sqlite3_bind_text(insertStatement, 2, nameStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 3, categoryStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 4, subCategoryStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 5, dateStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 6, priorityStr.utf8String, -1, nil)
                sqlite3_bind_int(insertStatement, 7, Int32(alertID))
                
                if sqlite3_step(insertStatement) == SQLITE_DONE{
                    let rowId = sqlite3_last_insert_rowid(db)
                    print("succefull inserted \(rowId)")
                    //newAlert = nil // clear newAlert
                }
                else{
                    print("couldnt insert row")
                    returnCode = false
                }
                
                sqlite3_finalize(insertStatement)
                
            }
            else {
                print("statement could not be prepared")
                returnCode = false
            }
            
            sqlite3_close(db)
            
        }
        else {
            print("unable to open Db")
            returnCode = false
        }
        return returnCode
    }
    
    //MARK: Database functions for Tasks
    func deleteTask(id: Int) -> Bool {
        var db : OpaquePointer? = nil
        var returnCode = false
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            
            var deleteStatement : OpaquePointer? = nil
            let deleteQuery : String = "delete from Tasks where Id = ?"
            
            if sqlite3_prepare_v2(db, deleteQuery, -1, &deleteStatement, nil) == SQLITE_OK {
                
                sqlite3_bind_int(deleteStatement, 1, Int32(id))
                
                if sqlite3_step(deleteStatement) == SQLITE_DONE {
                    print("Deleted task \(id)")
                    returnCode = true
                } else {
                    print("Could not delete task \(id)")
                }
                
                sqlite3_finalize(deleteStatement)
            } else {
                print("Could not prepare delete task statement")
            }
            
            sqlite3_close(db)
        } else {
            print("Could not open database")
        }
        
        return returnCode
    }
    
    func updateTask(task : Task) -> Bool {
        var db : OpaquePointer? = nil
        var returnCode = false
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            
            var updateStatement : OpaquePointer? = nil
            let updateQuery : String = "update Tasks set Title=?, Status=?, Priority=?, TaskDueDate=?, DaysInAdvance=?, Note_Id = ? where Id=?"
            
            if sqlite3_prepare_v2(db, updateQuery, -1, &updateStatement, nil) == SQLITE_OK {
                
                var cTitle = task.title! as NSString
                var intStatus = task.status! as NSNumber
                var cDueDate : NSString?
                if task.taskDueDate == nil {
                    cDueDate = nil
                } else {
                    cDueDate = task.taskDueDate! as NSString
                }

                
                sqlite3_bind_text(updateStatement, 1, cTitle.utf8String, -1, nil)
                sqlite3_bind_int(updateStatement, 2, Int32(intStatus))
                sqlite3_bind_int(updateStatement, 3, Int32(task.priority!))
                
                if cDueDate == nil {
                    sqlite3_bind_null(updateStatement, 4)
                } else {
                    sqlite3_bind_text(updateStatement, 4, cDueDate!.utf8String, -1, nil)
                }
                sqlite3_bind_int(updateStatement, 5, Int32(task.daysInAdvance!))
                
                if task.note == nil {
                    sqlite3_bind_null(updateStatement, 6)
                } else {
                    sqlite3_bind_int(updateStatement, 6, Int32(task.note!.id!))
                }
                
                sqlite3_bind_int(updateStatement, 7, Int32(task.id!))
                
                if sqlite3_step(updateStatement) == SQLITE_DONE {
                    print("Updated task \(task.id) | \(task.title)")
                    returnCode = true
                } else {
                    print("Could not update task \(task.id) | \(task.title)")
		}
                
                sqlite3_finalize(updateStatement)
            } else {
                print("Could not prepare update task statement")
	    }
            
            sqlite3_close(db)
        } else {
            print("Could not open database")
        }
        
        return returnCode
    }

    func getTaskById(id: Int) -> Task {
        var task : Task = Task()
        
        var db : OpaquePointer? = nil
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            
            var selectStatement : OpaquePointer? = nil
            let selectQuery : String = "select * from Tasks where Id = ?"
            
            if sqlite3_prepare_v2(db, selectQuery, -1, &selectStatement, nil) == SQLITE_OK {
                
                sqlite3_bind_int(selectStatement, 1, Int32(id))
                
                if sqlite3_step(selectStatement) == SQLITE_ROW {
                    let id : Int = Int(sqlite3_column_int(selectStatement, 0))
                    let user_id : Int = Int(sqlite3_column_int(selectStatement, 1))
                    let cTitle = sqlite3_column_text(selectStatement, 2)
                    let intStatus = Int(sqlite3_column_int(selectStatement, 3))
                    let priority = Int(sqlite3_column_int(selectStatement, 4))
                    let cTaskDueDate = sqlite3_column_text(selectStatement, 5)
                    let daysInAdvance = Int(sqlite3_column_int(selectStatement, 6))
                    
                    let note_id : Int? = Int(sqlite3_column_int(selectStatement, 7))
                    var note : Note? = nil
                    if (note_id != nil) {
                        note = getNoteById(id: note_id!)
                    }
                    
                    let title = String(cString: cTitle!)
                    let status = (intStatus as NSNumber).boolValue
                    
                    var taskDueDate : String?
                    if(cTaskDueDate != nil) {
                        taskDueDate = String(cString: cTaskDueDate!)
                    }
                    
                    task = Task.init(row: id, user_id: user_id, title: title, status: status, priority: priority, taskDueDate: taskDueDate, daysInAdvance: daysInAdvance, note: note)
                }
                
                sqlite3_finalize(selectStatement)
            } else {
                print("Could not prepare select task by id statement")
            }
            
            sqlite3_close_v2(db)

        } else {
            print("Could not open database")
        }
        return task
    }
    
    func getTasksByUser(user_id: Int) -> [Task] {
        var tasks : [Task] = []
    
        var db : OpaquePointer? = nil
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            
            var selectStatement : OpaquePointer? = nil
            let selectQuery : String = "select * from Tasks where User_Id = ?"
            
            if sqlite3_prepare_v2(db, selectQuery, -1, &selectStatement, nil) == SQLITE_OK {
                
                sqlite3_bind_int(selectStatement, 1, Int32(user_id))
                
                while sqlite3_step(selectStatement) == SQLITE_ROW {
                    let id : Int = Int(sqlite3_column_int(selectStatement, 0))
                    let user_id : Int = Int(sqlite3_column_int(selectStatement, 1))
                    let cTitle = sqlite3_column_text(selectStatement, 2)
                    let intStatus = Int(sqlite3_column_int(selectStatement, 3))
                    let priority = Int(sqlite3_column_int(selectStatement, 4))
                    let cTaskDueDate = sqlite3_column_text(selectStatement, 5)
                    let daysInAdvance = Int(sqlite3_column_int(selectStatement, 6))
                    
                    let note_id : Int? = Int(sqlite3_column_int(selectStatement, 7))
                    var note : Note? = nil
                    if (note_id != nil) {
                        note = getNoteById(id: note_id!)
                    }
                    
                    let title = String(cString: cTitle!)
                    let status = (intStatus as NSNumber).boolValue
                    
                    var taskDueDate : String?
                    if(cTaskDueDate != nil) {
                        taskDueDate = String(cString: cTaskDueDate!)
                    }
                    
                    let task : Task = Task.init(row: id, user_id: user_id, title: title, status: status, priority: priority, taskDueDate: taskDueDate, daysInAdvance: daysInAdvance, note: note)
                    
                    tasks.append(task)
                    
                    print("Result tasks:")
                    print("Id: \(id) | UserId: \(user_id) | Title: \(title) | NoteId: \(note_id)")
                }
                
                sqlite3_finalize(selectStatement)
            } else {
                print("Could not prepare select tasks by user statement")
            }
            
            sqlite3_close(db)
        } else {
            print("Could not open database")
        }
        
        return tasks
    }
    
    func insertTask(task: Task) -> Bool {
        var db : OpaquePointer? = nil
        var returnCode : Bool = false
        //var returnCode : Bool = false
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            var insertStatement :OpaquePointer? = nil
            let insertQuery : String = "insert into Tasks values(NULL, ?, ?, ?, ?, ?, ?, ?)"
            
            if sqlite3_prepare_v2(db, insertQuery, -1, &insertStatement, nil) == SQLITE_OK {
                
                let cTitle = task.title! as NSString
                
                var cDueDate : NSString?
                if task.taskDueDate == nil {
                    cDueDate = nil
                } else {
                    cDueDate = task.taskDueDate! as NSString
                }

                let intStatus = task.status! as NSNumber
                
                sqlite3_bind_int(insertStatement, 1, Int32(task.user_id!))
                sqlite3_bind_text(insertStatement, 2, cTitle.utf8String, -1, nil)
                sqlite3_bind_int(insertStatement, 3, Int32(intStatus))
                sqlite3_bind_int(insertStatement, 4, Int32(task.priority!))
                if cDueDate == nil {
                    sqlite3_bind_null(insertStatement, 5)
                } else {
                    sqlite3_bind_text(insertStatement, 5, cDueDate!.utf8String, -1, nil)
                }
                sqlite3_bind_int(insertStatement, 6, Int32(task.daysInAdvance!))
                if task.note == nil {
                    sqlite3_bind_null(insertStatement, 7)
                } else {
                    sqlite3_bind_int(insertStatement, 7, Int32(task.note!.id!))
                }
                
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    returnCode = true
                    let rowID = Int(sqlite3_last_insert_rowid(db))
                    print("Successfully inserted note into id: \(rowID)")
                    
                    currentTask = nil
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
    
    //MARK: Database functions for Notes
    func deleteNote(id: Int) -> Bool {
        var db : OpaquePointer? = nil
        var returnCode = false
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            var deleteStatement : OpaquePointer? = nil
            let deleteQuery: String = "delete from Notes where Id = ?"
            
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
    
    func updateNote(note : Note) -> Bool {
        var db : OpaquePointer? = nil
        var returnCode = false
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            
            var updateStatement : OpaquePointer? = nil
            let updateQuery : String = "update Notes set Content = ? where Id = ?"
            
            if sqlite3_prepare_v2(db, updateQuery, -1, &updateStatement, nil) == SQLITE_OK {
                
                let cContent = note.content! as NSString
                
                sqlite3_bind_text(updateStatement, 1, cContent.utf8String, -1, nil)
                sqlite3_bind_int(updateStatement, 2, Int32(note.id!))
                
                if sqlite3_step(updateStatement) == SQLITE_DONE {
                    print("Updated note \(note.id) | \(note.content)")
                    returnCode = true
                } else {
                    print("Could not update note \(note.id) | \(note.content)")
                }
                
                sqlite3_finalize(updateStatement)
            } else {
                print("Could not prepare update note statement")
            }
            
            sqlite3_close(db)
        } else {
            print("Could not open database")
        }
        
        return returnCode
    }
    
    func getNoteById(id: Int) -> Note? {
        var note : Note? = nil
        
        var db : OpaquePointer? = nil
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            var selectStatement : OpaquePointer? = nil
            let selectQuery : String = "select * from Notes where Id = ?"
            
            if sqlite3_prepare_v2(db, selectQuery, -1, &selectStatement, nil) == SQLITE_OK {
                
                sqlite3_bind_int(selectStatement, 1, Int32(id))
                
                if sqlite3_step(selectStatement) == SQLITE_ROW {
                    let id : Int = Int(sqlite3_column_int(selectStatement, 0))
                    let cContent = sqlite3_column_text(selectStatement, 1)
                    
                    let content = String(cString: cContent!)
                    
                    note = Note.init(row: id, content: content)
                }
                
                sqlite3_finalize(selectStatement)
            } else {
                print("Could not prepare select note by task statement")
            }
            sqlite3_close(db)
        } else {
            print("Could not open the database")
        }
        
        return note
    }
    
    func insertNote(note: Note) -> Int? {
        var db : OpaquePointer? = nil
        var noteId : Int? = nil
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            var insertStatement :OpaquePointer? = nil
            let insertQuery : String = "insert into Notes values(NULL, ?)"
            
            if sqlite3_prepare_v2(db, insertQuery, -1, &insertStatement, nil) == SQLITE_OK {
                let cContent = note.content! as NSString
                
                sqlite3_bind_text(insertStatement, 1, cContent.utf8String, -1, nil)
                
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    noteId = Int(sqlite3_last_insert_rowid(db))
                    print("Successfully inserted note into id: \(noteId)")
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
        
        return noteId
    }
    
    
    //MARK: =====================Sherwin Code block =============================================

    //MEthod that is used to Reset the password of the user
    func resetPassword(user: User, newPassword : String) -> Bool {
        var db : OpaquePointer? = nil
        var returnCode : Bool = true
        
        if sqlite3_open(self.databasePath!, &db) == SQLITE_OK {
            
            var updateStatement : OpaquePointer? = nil
            let updateStatementString : String = "update Users set Password = ? where ID = ?"
            
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
//Function is used to search for useers email when resetting password
    func getUserByEmail (email : String) -> User? {
       // var user : User = User()
       var user : User? = nil
        
        var db : OpaquePointer? = nil
        
        if sqlite3_open(self.databasePath!, &db) == SQLITE_OK {
            
            var findUserStatement : OpaquePointer? = nil
            let findUserStatementString : String = "select Id, Email, Question, Answer from Users where Email = ?"
            
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
  //Function is used to Verify the users credentials and find specific user in database while signing in
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
    //Function is used to register the user to the  database
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
    
//Function is used to load the calendars
    func loadCalendars() {
        let calendars = self.eventStore!.calendars(for: .reminder)
        
        for calendar in calendars as [EKCalendar] {
            print("Calendar = \(calendar.title)")
        }
        print("Default Calendars: \(self.eventStore!.defaultCalendarForNewReminders())")
    }
    //Shrwin : This Function is used to check and make sure reminder permission have been granted
    func checkRemindersPermission() {
        print("Checking access permission to Reminders ...")
        
        switch EKEventStore.authorizationStatus(for: .reminder) {
        case .authorized:
            print("Already granted access to Reminders")
            self.loadCalendars()
        case .notDetermined:
            print("Not determined. Asking for access Reminders")
            self.eventStore!.requestAccess(to: EKEntityType.reminder, completion: {
                (isAllowed, error) in
                if isAllowed {
                    print("Access to Reminders is granted")
                    self.loadCalendars()
                } else {
                    print("Access to Reminders is not granted")
                    print(error?.localizedDescription)
                }
            })
        case .restricted:
            print("Restricted access to Reminders")
        case .denied:
            print("Access to Reminders is denied")
        @unknown default:
            print("Default: Not determined. Asking for access Reminders")
            self.eventStore!.requestAccess(to: .reminder, completion: {
                (isAllowed, error) in
                if isAllowed {
                    print("Access to Reminders is granted")
                    self.loadCalendars()
                } else {
                    print("Access to Reminders is not granted")
                    print(error?.localizedDescription)
                }
            })
        }
    }
    //Sherwin : Verify all the calendat permission
    func checkCalendarsPermission() {
        print("Checking access permission to Calendars ...")
        
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            print("Already granted access to Calendars")
            self.checkRemindersPermission()
        case .notDetermined:
            print ("Not determined. Asking for access Calendars")
            self.eventStore!.requestAccess(to: .event, completion: {
                (isAllowed, error) in
                if isAllowed {
                    print("Access to Calendars is granted")
                    self.eventStore = EKEventStore()
                    self.checkRemindersPermission()
                } else {
                    print("Access to Calendats is not granted")
                    print(error?.localizedDescription)
                }
            })
        case .restricted:
            print("Restricted access to Calendars")
        case .denied:
            print("Access to Calendars is denied")
        @unknown default:
            print("Default: Not determined. Asking for access Calendars")
            self.eventStore!.requestAccess(to: .reminder, completion: {
                (isAllowed, error) in
                if isAllowed {
                    print("Access to Calendars is granted")
                    self.eventStore = EKEventStore()
                    self.checkRemindersPermission()
                } else {
                    print("Access to Calendars is not granted")
                    print(error?.localizedDescription)
                }
            })
        }
    }
    
    //MARK: Database functions for Reminders
    func insertReminder(reminder : Reminder) -> Bool
    {
        var db : OpaquePointer? = nil
        var returnCode : Bool = true
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK
        {
            var insertStatement : OpaquePointer? = nil
            let insertStatementString = "insert into Reminders values(NULL,?,?)"
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK
            {
                let namestr = reminder.reminderName! as NSString
                let dateStr = reminder.reminderDate! as NSString
  
                
                sqlite3_bind_text(insertStatement, 1, namestr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 2, dateStr.utf8String, -1, nil)
              
                
                if sqlite3_step(insertStatement) == SQLITE_DONE{
                    let rowId = sqlite3_last_insert_rowid(db)
                    print("Succeful inserted reminder into \(rowId)")
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
    
 //Function is used to update the remnder
    func updateReminder(reminder : Reminder) -> Bool {
        var db : OpaquePointer? = nil
        var returnCode = false
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            
            var updateStatement : OpaquePointer? = nil
            var updateQuery : String = "update Reminders set ReminderName = ?, ReminderDate = ? where ID = ?"
            
            if sqlite3_prepare(db, updateQuery, -1, &updateStatement, nil) == SQLITE_OK {
                
                let cReminderName = reminder.reminderName! as NSString
                let cReminderDate = reminder.reminderDate! as NSString
                
                sqlite3_bind_text(updateStatement, 1,  cReminderName.utf8String, -1, nil)
                sqlite3_bind_text(updateStatement, 2, cReminderDate.utf8String, -1, nil)
            
                
                if sqlite3_step(updateStatement) == SQLITE_DONE {
                    returnCode = true
                   
                    print("Updated Reminder ")
                } else {
                    print("Could not update reminders")
                }
                
                sqlite3_finalize(updateStatement)
            } else {
                print("Could not prepare Update for reminders")
            }
            
            sqlite3_close(db)
        } else {
            print("Could not open the database")
        }
        
        return returnCode
    }
    
    //Method is = used to get the reminder by Id
    func getReminderById(id : Int) -> Reminder? {
        var reminder : Reminder? = nil
        
        var db : OpaquePointer? = nil
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            var selectStatement : OpaquePointer? = nil
            var selectQuery : String = "select * from Reminders where Id = ?"
            
            if sqlite3_prepare_v2(db, selectQuery, -1, &selectStatement, nil) == SQLITE_OK {
                
                sqlite3_bind_int(selectStatement, 1, Int32(id))
                
                if sqlite3_step(selectStatement) == SQLITE_ROW {
                    let id : Int = Int(sqlite3_column_int(selectStatement, 0))
                    let creminderName = sqlite3_column_text(selectStatement, 1)
                    let creminderDate = sqlite3_column_text(selectStatement, 2)
                  
                    
                    let contentReminderName = String(cString: creminderName!)
                    let contentReminderDate = String(cString: creminderDate!)
                    
                    reminder = Reminder.init(row: id, reminderName: contentReminderName, reminderDate: contentReminderDate);
                }
                sqlite3_finalize(selectStatement)
            } else {
                print("Could not prepare select reminder by id statement")
            }
            sqlite3_close(db)
        } else {
            print("Could not open the database")
        }
        
        return reminder
    }
    
    //Method is used to Delete the reminder from the database
    func deleteReminder(id: Int) -> Bool {
        var db : OpaquePointer? = nil
        var returnCode = false
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            var deleteStatement : OpaquePointer? = nil
            var deleteQuery: String = "delete from Reminders where Id = ?"
            
            if sqlite3_prepare_v2(db, deleteQuery, -1, &deleteStatement, nil) == SQLITE_OK {
                
                sqlite3_bind_int(deleteStatement, 1, Int32(id))
                
                if sqlite3_step(deleteStatement) == SQLITE_DONE {
                    returnCode = true
                    print("Successfully deleted reminder id: \(id)")
                } else {
                    print("Could not delete the reminder id:\(id)")
                }
                
                sqlite3_finalize(deleteStatement)
            } else {
                print("Could not prepare delete reminder statement")
            }
            sqlite3_close(db)
        } else {
            print("Could not open the database")
        }
        
        return returnCode
    }

   //MARK: =================END_OF_Sherwins Code Block============================
    
    
    
    
    
    //MARK: =====================BRIAN'S_CODE_BLOCK==============================================
    //MARK: ========== Contacts Database Functions ==============
    func insertContactIntoDatabase(contact : Contact) -> Bool
    {
        var db : OpaquePointer? = nil
        var returnCode : Bool = true
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK
        {
            var insertStatement : OpaquePointer? = nil
            let insertStatementString : String = "insert into contacts values(NULL,?,?,?,?,?,?,?,?,?)"
            
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK{
                
                let userInt = contact.user! as NSInteger
                let cName = contact.name! as NSString
                let cOrganization = contact.organization! as NSString
                let cTitle = contact.title! as NSString
                let cPhone = contact.phone! as NSString
                let cEmail = contact.email! as NSString
                let cDiscord = contact.discord! as NSString
                let cSlack = contact.slack! as NSString
                let cNotes = contact.notes! as NSString
                
                sqlite3_bind_int(insertStatement, 1, Int32(userInt))
                sqlite3_bind_text(insertStatement, 2, cName.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 3, cOrganization.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 4, cTitle.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 5, cPhone.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 6, cEmail.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 7, cDiscord.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 8, cSlack.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 9, cNotes.utf8String, -1, nil)
                
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    let rowID = sqlite3_last_insert_rowid(db)
                    print("Successfully inserted into row# \(rowID):")
                    print("\(rowID) | \(userInt) | \(contact.name!) | \(String(describing: contact.organization)) | \(String(describing: contact.title)) | \(String(describing: contact.phone)) | \(String(describing: contact.email)) | \(String(describing: contact.discord)) | \(String(describing: contact.slack)) | \(String(describing: contact.notes))")
                }else{
                    print("Could not insert row")
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
        refreshDatabaseFromApp()
        getContactsByUserId(userID: currentUser!.id!)
        return returnCode
    }
    
    func getContactsByUserId(userID : Int){
        print("> getContactsByUserId() started...")
        //prep
        contacts.removeAll()
        print(">>>> called contacts.removeAll()")
        
        var db : OpaquePointer? = nil
        
        //action
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK
        {
            print("> Successfully opened connection to database at \(self.databasePath ?? "Unknown")")
            
            var queryStatement : OpaquePointer? = nil
            let queryStatementString : String = "select * from Contacts where user = ?"
            
            print("Testing if SQLite is Ok....")
            
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                print("SQLite is ok.")
                sqlite3_bind_int(queryStatement, 1, Int32(userID))
                print("Contacts retrieved from db for user (\(userID)):")
                
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    
                    let id : Int = Int(sqlite3_column_int(queryStatement, 0))
                    let user : Int = Int(sqlite3_column_int(queryStatement, 1))
                    let cName = sqlite3_column_text(queryStatement, 2)
                    let cOrganization = sqlite3_column_text(queryStatement, 3)
                    let cTitle = sqlite3_column_text(queryStatement, 4)
                    let cPhone = sqlite3_column_text(queryStatement, 5)
                    let cEmail = sqlite3_column_text(queryStatement, 6)
                    let cDiscord = sqlite3_column_text(queryStatement, 7)
                    let cSlack = sqlite3_column_text(queryStatement, 8)
                    let cNotes = sqlite3_column_text(queryStatement, 9)
                    
                    let name = String(cString: cName!)
                    let organization = String(cString: cOrganization!)
                    let title = String(cString: cTitle!)
                    let phone = String(cString: cPhone!)
                    let email = String(cString: cEmail!)
                    let discord = String(cString: cDiscord!)
                    let slack = String(cString: cSlack!)
                    let notes = String(cString: cNotes!)
                    
                    let newContact : Contact = Contact.init(theRow: id, theOwerUser: user, theName: name, theOrganization: organization, theTitle: title, thePhone: phone, theEmail: email, theDiscord: discord, theSlack: slack, theNotes: notes)
                    
                    contacts.append(newContact)
                    
                   print("\(id) | \(user) | \(name) | \(organization) | \(title) | \(phone) | \(email) | \(discord) | \(slack) | \(notes)")
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
    
    func UpdateContact(contact: Contact)->Bool
    {
        var db : OpaquePointer? = nil
        var returnCode : Bool = true
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK
        {
            var updateStatement : OpaquePointer? = nil
            let updateStatementString : String = "UPDATE contacts SET Name = ?, Organization = ?, Title = ?, Phone = ?, Email = ?, Discord = ?, Slack = ?, Notes = ? WHERE ID = ?"
            
            if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK{
                
                let contactID = currentContact!.id! as NSInteger
                let cName = contact.name! as NSString
                let cOrganization = contact.organization! as NSString
                let cTitle = contact.title! as NSString
                let cPhone = contact.phone! as NSString
                let cEmail = contact.email! as NSString
                let cDiscord = contact.discord! as NSString
                let cSlack = contact.slack! as NSString
                let cNotes = contact.notes! as NSString
                
                
                sqlite3_bind_text(updateStatement, 1, cName.utf8String, -1, nil)
                sqlite3_bind_text(updateStatement, 2, cOrganization.utf8String, -1, nil)
                sqlite3_bind_text(updateStatement, 3, cTitle.utf8String, -1, nil)
                sqlite3_bind_text(updateStatement, 4, cPhone.utf8String, -1, nil)
                sqlite3_bind_text(updateStatement, 5, cEmail.utf8String, -1, nil)
                sqlite3_bind_text(updateStatement, 6, cDiscord.utf8String, -1, nil)
                sqlite3_bind_text(updateStatement, 7, cSlack.utf8String, -1, nil)
                sqlite3_bind_text(updateStatement, 8, cNotes.utf8String, -1, nil)
                sqlite3_bind_int(updateStatement, 9, Int32(contactID))
                
                if sqlite3_step(updateStatement) == SQLITE_DONE {
                    let rowID = sqlite3_last_insert_rowid(db)
                    print("Successfully updated row \(rowID)")
                }else{
                    print("Counld not insert row")
                    returnCode = false
                }
                sqlite3_finalize(updateStatement)
                
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
        //MARK : Troublesooting
        currentContact = contact
        refreshDatabaseFromApp()
        getContactsByUserId(userID: currentUser!.id!)
        return returnCode
    }
    
    func deleteContact(id: Int) {
        var db : OpaquePointer? = nil
       // var returnCode = false
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            
            var deleteStatement : OpaquePointer? = nil
            let deleteQuery : String = "delete from Contacts where Id = ?"
            
            if sqlite3_prepare_v2(db, deleteQuery, -1, &deleteStatement, nil) == SQLITE_OK {
                
                sqlite3_bind_int(deleteStatement, 1, Int32(id))
                
                if sqlite3_step(deleteStatement) == SQLITE_DONE {
                    print("Deleted contact \(id)")
                   // returnCode = true
                } else {
                    print("Could not delete contact \(id)")
                }
                
                sqlite3_finalize(deleteStatement)
            } else {
                print("Could not prepare delete contact")
            }
            
            sqlite3_close(db)
        } else {
            print("Could not open database")
        }
    }

//    //MARK: ============ 'Alerts' ==== Database Functions  ==================
//
//    func insertAlertIntoDatabase(alert : Alert) -> Bool
//    {
//        var db : OpaquePointer? = nil
//        var returnCode : Bool = true
//
//        if sqlite3_open(self.databasePath, &db) == SQLITE_OK
//        {
//            var insertStatement : OpaquePointer? = nil
//            let insertStatementString : String = "insert into alerts values(NULL,?,?)"
//
//            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK{
//
//                let cName = alert.name as NSString
//                let time = alert.time as NSInteger
//
//                sqlite3_bind_text(insertStatement, 1, cName.utf8String, -1, nil)
//                sqlite3_bind_int(insertStatement, 2, Int32(time))
//
//
//                if sqlite3_step(insertStatement) == SQLITE_DONE {
//                    let rowID = sqlite3_last_insert_rowid(db)
//                    print("Successfully inserted into row# \(rowID):")
//                    newAlert?.alertID = Int(rowID)
//                    print("\(rowID) | \(alert.name) | \(alert.time)")
//                }else{
//                    print("Counld not insert row")
//                    returnCode = false
//                }
//                sqlite3_finalize(insertStatement)
//
//            }else{
//                print("Insert statement could not be prepared")
//                returnCode = false
//            }
//            sqlite3_close(db)
//        }
//        else
//        {
//            print("Unable to open database")
//            returnCode = false
//        }
//        refreshDatabaseFromApp()
//
//        //getAlertsByUserId()
//
//        return returnCode
//    }
//
//    func getAlertbyId(id : Int)->Alert{
//
//        var db : OpaquePointer? = nil
//        var newAlert : Alert? = nil
//
//        //action
//        if sqlite3_open(self.databasePath, &db) == SQLITE_OK
//        {
//            print("> Successfully opened connection to database at \(self.databasePath ?? "Unknown")")
//
//            var queryStatement : OpaquePointer? = nil
//            let queryStatementString : String = "select * from Alerts where AlertID = ?"
//
//            print("Testing if SQLite is Ok....")
//
//            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
//                print("SQLite is ok.")
//                sqlite3_bind_int(queryStatement, 1, Int32(id))
//
//                while sqlite3_step(queryStatement) == SQLITE_ROW {
//
//                    let id : Int = Int(sqlite3_column_int(queryStatement, 0))
//                    let cName = sqlite3_column_text(queryStatement, 1)
//                    let date : Int = Int(sqlite3_column_int(queryStatement, 2))
//
//                    let name = String(cString: cName!)
//
//
//                    newAlert = Alert.init(alertID: id, name: name, time: date)
//
//                    print("\(id) | \(name) | \(date)")
//                }
//                sqlite3_finalize(queryStatement)
//            }else{
//                print("SQLite is not ok.")
//                print("Select statement could not be prepared")
//            }
//            print("Closing DB connection...")
//            sqlite3_close(db)
//        }
//        else{
//            print("Unable to open database")
//        }
//        return newAlert!
//    }
//
//
//    func UpdateAlert(alert: Alert)->Bool
//    {
//        var db : OpaquePointer? = nil
//        var returnCode : Bool = true
//
//        if sqlite3_open(self.databasePath, &db) == SQLITE_OK
//        {
//            var updateStatement : OpaquePointer? = nil
//            let updateStatementString : String = "UPDATE Alerts SET Name = ?, Date = ? WHERE ID = ?"
//
//            if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK{
//
//                let alertID = alert.alertID! as NSInteger
//                let cName = alert.name as NSString
//                let date = alert.time as NSInteger
//
//                sqlite3_bind_text(updateStatement, 1, cName.utf8String, -1, nil)
//                sqlite3_bind_int(updateStatement, 2, Int32(date))
//                sqlite3_bind_int(updateStatement, 3, Int32(alertID))
//
//                if sqlite3_step(updateStatement) == SQLITE_DONE {
//                    let rowID = sqlite3_last_insert_rowid(db)
//                    print("Successfully updated row \(rowID)")
//                }else{
//                    print("Counld not update row")
//                    returnCode = false
//                }
//                sqlite3_finalize(updateStatement)
//
//            }else{
//                print("Insert statement could not be prepared")
//                returnCode = false
//            }
//            sqlite3_close(db)
//        }
//        else
//        {
//            print("Unable to open database")
//            returnCode = false
//        }
//        currentAlert = alert
//        refreshDatabaseFromApp()
//        return returnCode
//    }
//
//    func deleteAlert(id: Int) {
//        var db : OpaquePointer? = nil
//        // var returnCode = false
//
//        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
//
//            var deleteStatement : OpaquePointer? = nil
//            let deleteQuery : String = "delete from Alerts where Id = ?"
//
//            if sqlite3_prepare_v2(db, deleteQuery, -1, &deleteStatement, nil) == SQLITE_OK {
//
//                sqlite3_bind_int(deleteStatement, 1, Int32(id))
//
//                if sqlite3_step(deleteStatement) == SQLITE_DONE {
//                    print("Deleted alert \(id)")
//                    // returnCode = true
//                } else {
//                    print("Could not delete alert \(id)")
//                }
//
//                sqlite3_finalize(deleteStatement)
//            } else {
//                print("Could not prepare delete alert")
//            }
//
//            sqlite3_close(db)
//        } else {
//            print("Could not open database")
//        }
//    }
//    //MARK: ============= ALERT & NOTIFICATION =========================
//
//    // For DueDate saveFunction
//    func saveAlertToDbAndRegister() // Called when clicking SaveDueDate (before dueDate.db functions)
//    {
//        if currentAlert?.alertID == nil {
//            print("currentAlert?.alertID == nil")
//            // If dueDate has no currentAlert (only the case when creating a new dueDate, or updating a dueDate with no alert (adding and registering an Alert)
//            if newAlert == nil {
//                print("newAlert = nil")
//                return
//            }else{ // We are creating a duedate, and we have a new alert
//                if insertAlertIntoDatabase(alert: newAlert!) == true{
//                    print("Alert saved to db")
//                    currentAlert = newAlert
//                    print("currentAlert = newAlert")
//                    //MARK: DueDate needs an 'Alert :Int' property
//                    //currentDueDate.alert? = currentAlert?.alertID
//
//                    //Schedule and register new alert
//                    scheduleNotification()
//                    print("scheduled notification")
//                    registerCategories()
//
//                }else{
//                    print("Alert not saved to db")
//                }
//            }
//        }else{// If dueDate HAS a currentAlert (only the case when editing a dueDate (updating db unregistering previous alert and registering new Alert)
//            print("currentAlert?.alertID != nil")
//            // MARK: Logic for editing dueDate that had an Alert
//            if newAlert == nil {
//                print("newAlert == nil")
//                return
//            }else{
//                if insertAlertIntoDatabase(alert: newAlert!) == true{
//                    print("Alert saved to db")
//
//                    // unscheduleNotification(currentAlert.alertID)
//
//                    currentAlert = newAlert
//                    //MARK: DueDate needs an 'Alert :Int' property
//                    //currentDueDate.alert? = currentAlert?.alertID
//
//                    //Schedule and register new alert
//                    scheduleNotification()
//                    registerCategories()
//
//                    currentAlert = nil // clear currentAlert
//                    newAlert = nil // clear newAlert
//                }else{
//                    print("Alert not saved to db")
//                }
//            }
//        }
//    }
//
//
//
//    func scheduleNotification(){
//
//        let alertIdNumberForIdent = currentAlert?.alertID! as! NSNumber
//        let alertIdStringForIdent = alertIdNumberForIdent.stringValue
//
//        //        let name = tfAlertTextField.text ?? ""
//        let center = UNUserNotificationCenter.current()
//        let content = UNMutableNotificationContent()
//        content.title = "Alert for:  \(String(describing: currentDueDate))"
//        content.body = "Alert note: \(String(describing: currentAlert?.name))"
//        content.categoryIdentifier = "alarm"
//        content.userInfo = ["custom  data" : "Some data stored in dictionary"]
//        content.sound = UNNotificationSound.default
//
//        // current time
//        let now = Date()
//
//        // ensure trigger time is on the minute
//        let timeFromIntervalToAlarm = currentAlert?.time
//        let timeFromintervalToCurrent = Int(floor(now.timeIntervalSinceReferenceDate/60) * 60)
//        let intervalFromCurrentToAlarm = timeFromIntervalToAlarm! - timeFromintervalToCurrent
//
//        //Sets trigger
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(intervalFromCurrentToAlarm), repeats: false)
//
//        // (FOR TESTING) Show alert 10 seconds after being scheduled
//        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
//
//
//        // Builds UNNotification Request
//        let request = UNNotificationRequest(identifier: alertIdStringForIdent, content: content, trigger: trigger)
//        //Adding request to notification center
//        center.add(request)
//    }
//
//    func registerCategories(){
//        let center = UNUserNotificationCenter.current()
//        center.delegate = self as? UNUserNotificationCenterDelegate
//
//        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
//        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])
//
//        center.setNotificationCategories([category])
//    }
//
//    // schedule delivery
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didRecieve response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void){
//
//        // pull out buried userInfo dictionary
//        let userInfo = response.notification.request.content.userInfo
//
//        if let customData = userInfo["customData"] as? String {
//            print("Custom data recieved; \(customData)")
//
//            switch response.actionIdentifier {
//            case UNNotificationDefaultActionIdentifier:
//                // the user swiped to unlock
//                print("Default identifier")
//
//            case "show":
//                // the user tapped the "Tell me more..." button
//                break
//            default:
//                break
//
//            }
//        }
//        completionHandler()
//    }
//
    
    //MARK: ============= END OF ALERT & NOTIFICATION =========================
    
    
    //MARK: =================END_OF_BRIAN'S_CODE_BLOCK============================
    //MARK: ========================= SETUP FUNCTIONS ===========================

    //MARK: Prepare Database and Check Permissions
    

    func refreshDatabaseFromApp()
    {
        var success = false
        let fileManager = FileManager.default
        
        success = fileManager.fileExists(atPath: databasePath!)
        
        if success{
            print("Database exists...")
           
        }
        print("Building Database from resources...")
        let databasePathFromApp = Bundle.main.resourcePath?.appending("/" + databaseName!)
        
        try?fileManager.copyItem(atPath: databasePathFromApp!, toPath: databasePath!)
        
        return
    }

    //MARK: CreateAndCheck Database
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

        try?fileManager.copyItem(atPath: databasePathFromApp!, toPath: databasePath!)
        
        return
    }

    //MARK: Default functions
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDir = documentPaths[0]
        print("Documents directory: \(documentsDir)")
        databasePath = documentsDir.appending("/" + databaseName!)

        //MARK: 1 Brian Addition for Notification Authorization
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.alert, .badge, .sound]){(granted, error) in
            if granted {
                print("Granted authorization for notifications")
            } else {
                print("Authorization for notifications denied")
            }
        }
        
        // End of Mark 1
        
        checkAndCreateDatabase()
        
        self.eventStore = EKEventStore()
        checkCalendarsPermission()
        
        // Initialize Google sign-in
        GIDSignIn.sharedInstance()?.clientID = "472534012216-rc8s3uveu8buvh4qhbn0fjalba9p1srl.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.delegate = self
        
        //readContactDataFromDatabase()
        return true
    }
    
    //MARK: Methods for Google SignIn
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        } else {
            if(user?.userID != nil) {
                currentUser = User(row: 04122020, email: user.profile.email, password: "temp", name: user.profile.name, securityQuestion: 0, securityAnswer: "temp")
                
                let idToken = user.authentication.idToken
                signIncallback!()
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        currentUser = nil
    }
    

    //MARK: insert notification
    func insertNotificationIntoDatabase(notification : Notification) -> Bool
    {
        var db : OpaquePointer? = nil
        var returnCode : Bool = true
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK
        {
            var insertStatement : OpaquePointer? = nil
            let insertStatementString = "insert into Notifications values(NULL,?,?)"
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK
            {
                let statusStr = notification.status! as NSString
                let dateStr = notification.date! as NSString
                sqlite3_bind_text(insertStatement, 1, statusStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 2, dateStr.utf8String, -1, nil)
                if sqlite3_step(insertStatement) == SQLITE_DONE{
                    let rowId = sqlite3_last_insert_rowid(db)
                    print("succefull inserted \(rowId)")
                    notification.id = Int(rowId)
                }
                else{
                    print("couldnt insert notification")
                    returnCode = false
                }
                sqlite3_finalize(insertStatement)
            }
            else {
                print("statement could not be prepared")
                returnCode = false
            }
            sqlite3_close(db)
        }
        else {
            print("unable to open Db")
            returnCode = false
        }
        return returnCode
    }
    
    //MARK: update the notification
    func updateNotification(notification : Notification) -> Bool {
        var db : OpaquePointer? = nil
        var returnCode = false
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            var updateStatement : OpaquePointer? = nil
            var updateQuery : String = "update Notifications set  Status = ?, Date = ? where Id = ?"
            if sqlite3_prepare_v2(db, updateQuery, -1, &updateStatement, nil) == SQLITE_OK {
                var cStatus = notification.status! as NSString
                var cDate = notification.date! as NSString
                
                sqlite3_bind_text(updateStatement, 1, cStatus.utf8String, -1, nil)
                sqlite3_bind_text(updateStatement, 4, cDate.utf8String, -1, nil)
                if sqlite3_step(updateStatement) == SQLITE_DONE {
                    print("Updated notification \(notification.id) | \(notification.status)")
                    returnCode = true
                } else {
                    print("Could not update notification \(notification.id) | \(notification.status)")
                }
                sqlite3_finalize(updateStatement)
            } else {
                print("Could not prepare update notification statement")
            }
            sqlite3_close(db)
        } else {
            print("Could not open database")
        }

        return returnCode
    }

    //MARK: get notification by id
    func getNotificationById(id: Int) -> Notification {
        
        
        var db : OpaquePointer? = nil
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            var selectStatement : OpaquePointer? = nil
            var selectQuery : String = "select * from Notification where Id = ?"
            
            if sqlite3_prepare_v2(db, selectQuery, -1, &selectStatement, nil) == SQLITE_OK {
                
                sqlite3_bind_int(selectStatement, 1, Int32(id))
                
                if sqlite3_step(selectStatement) == SQLITE_ROW {
                    let id : Int = Int(sqlite3_column_int(selectStatement, 0))
                    let cStatus = sqlite3_column_text(selectStatement, 1)
                    let cDate = sqlite3_column_text(selectStatement, 2)
                    let status = String(cString: cStatus!)
                    let date = String(cString: cDate!)
                    
                    notification.initWithData(theRow: id, theStatus: status, theDate: date)
                    
                }
                
                sqlite3_finalize(selectStatement)
            } else {
                print("Could not prepare select notification by id")
            }
            sqlite3_close(db)
        } else {
            print("Could not open the database")
        }
        
        return notification
    }
    //MARK: delete notificatin by id
    func deleteNotification(id: Int) -> Bool {
        var db : OpaquePointer? = nil
        var returnCode = false
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            
            var deleteStatement : OpaquePointer? = nil
            var deleteQuery : String = "delete from Notification where Id = ?"
            
            if sqlite3_prepare_v2(db, deleteQuery, -1, &deleteStatement, nil) == SQLITE_OK {
                
                sqlite3_bind_int(deleteStatement, 1, Int32(id))
                
                if sqlite3_step(deleteStatement) == SQLITE_DONE {
                    print("Deleted notification \(id)")
                    returnCode = true
                } else {
                    print("Could not delete notification \(id)")
                }
                
                sqlite3_finalize(deleteStatement)
            } else {
                print("Could not prepare delete notification statement")
            }
            
            sqlite3_close(db)
        } else {
            print("Could not open database")
        }
        
        return returnCode
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
    //MARK: ========================= END OF SETUP FUNCTIONS ================================
    
    
}

