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
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    var window: UIWindow?

    var databaseName : String? = "RemindMe.db"
    var databasePath : String?
    
    var currentUser : User? = nil
    var currentTask : Task? = nil
    var currentDueDate : DueDate? = nil
    
    var securityQuestions = ["What is your mothers name?", "What is your best friend's name?", "Which school do you study at?"]

    var contacts : [Contact] = []
    
    var duedates : [DueDate] = []
    
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
            var updateStatementString = "UPDATE DueDates SET Name=?, Category=?, SubCategory=?, SelectedDate=?, Priority=? WHERE ID=?"
            if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK
            {
                
                let cName = duedate.name as! NSString
                let cCategory = duedate.category as! NSString
                let cSubCategory = duedate.subCategory as! NSString
                let cDate = duedate.date as! NSString
                let cPriority = duedate.priority as! NSString
                
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
            print("Successfully Opened database \(self.databasePath)")
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
                    
                    let name = String(cString: cname!)
                    let category = String(cString: ccategory!)
                    let subCategory = String(cString: csubCategory!)
                    let date = String(cString: cdate!)
                    let priority = String(cString: cpriority!)
                    
                    //TODO: Call getNoteByDueDateId
                    // Call getNoteByID here
                    var note : Note? = nil
                    
                    //TODO: Call getReminderByDueDateId
                    // Call getReminderByDueDateId here
                    var reminder : Reminder? = nil
                    
                    let data : DueDate = DueDate.init()
                    data.initWithData(theRow: id, theUserId: userId, theName: name, theCategory: category, theSubCategory: subCategory, theDate: date, thePriority: priority, theNote: note, theReminder: reminder)
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
                    
                    let name = String(cString: cname!)
                    let category = String(cString: ccategory!)
                    let subCategory = String(cString: csubCategory!)
                    let date = String(cString: cdate!)
                    let priority = String(cString: cpriority!)
                    
                    //TODO: Call getNoteByDueDateId
                    // Call getNoteByID here
                    var note : Note? = nil
                    
                    //TODO: Call getReminderByDueDateId
                    // Call getReminderByDueDateId here
                    var reminder : Reminder? = nil
                    
                    let data : DueDate = DueDate.init()
                    data.initWithData(theRow: id, theUserId: userId, theName: name, theCategory: category, theSubCategory: subCategory, theDate: date, thePriority: priority, theNote: note, theReminder: reminder)
                    
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
            var insertStatementString = "insert into DueDates values(NULL,?,?,?,?,?,?)"
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK
            {
                
                let userId : Int = currentUser!.id!
                let nameStr = duedate.name! as NSString
                let categoryStr = duedate.category! as NSString
                let subCategoryStr = duedate.subCategory! as NSString
                let dateStr = duedate.date! as NSString
                let priorityStr = duedate.priority! as NSString
                
                sqlite3_bind_int(insertStatement, 1, Int32(userId))
                sqlite3_bind_text(insertStatement, 2, nameStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 3, categoryStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 4, subCategoryStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 5, dateStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 6, priorityStr.utf8String, -1, nil)
                
                if sqlite3_step(insertStatement) == SQLITE_DONE{
                    let rowId = sqlite3_last_insert_rowid(db)
                    print("succefull inserted \(rowId)")
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
            var deleteQuery : String = "delete from Tasks where Id = ?"
            
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
            var updateQuery : String = "update Tasks set Title=?, Status=?, Priority=?, TaskDueDate=?, DaysInAdvance=? where Id=?"
            
            if sqlite3_prepare_v2(db, updateQuery, -1, &updateStatement, nil) == SQLITE_OK {
                
                var cTitle = task.title! as NSString
                var intStatus = task.status! as NSNumber
                var cTaskDueDate = task.taskDueDate! as NSString
                
                sqlite3_bind_text(updateStatement, 1, cTitle.utf8String, -1, nil)
                sqlite3_bind_int(updateStatement, 2, Int32(intStatus))
                sqlite3_bind_int(updateStatement, 3, Int32(task.priority!))
                sqlite3_bind_text(updateStatement, 4, cTaskDueDate.utf8String, -1, nil)
                sqlite3_bind_int(updateStatement, 5, Int32(task.daysInAdvance!))
                
                sqlite3_bind_int(updateStatement, 6, Int32(task.id!))
                
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
            var selectQuery : String = "select * from Tasks where Id = ?"
            
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
                    let note = getNoteByTask(task_id: id)
                    
                    let title = String(cString: cTitle!)
                    let status = (intStatus as NSNumber).boolValue
                    let taskDueDate = String(cString: cTaskDueDate!)
                    
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
            var selectQuery : String = "select * from Tasks where User_Id = ?"
            
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
                    let note = getNoteByTask(task_id: id)
                    
                    let title = String(cString: cTitle!)
                    let status = (intStatus as NSNumber).boolValue
                    let taskDueDate = String(cString: cTaskDueDate!)
                    
                    var task : Task = Task.init(row: id, user_id: user_id, title: title, status: status, priority: priority, taskDueDate: taskDueDate, daysInAdvance: daysInAdvance, note: note)
                    
                    tasks.append(task)
                    
                    print("Result tasks:")
                    print("Id: \(id) | UserId: \(user_id) | Title: \(title) | NoteId: \(note?.id)")
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
    
    func insertTask(task: Task) -> Int? {
        var db : OpaquePointer? = nil
        var rowID : Int? = nil
        //var returnCode : Bool = false
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            var insertStatement :OpaquePointer? = nil
            var insertQuery : String = "insert into Tasks values(NULL, ?, ?, ?, ?, ?, ?)"
            
            if sqlite3_prepare_v2(db, insertQuery, -1, &insertStatement, nil) == SQLITE_OK {
                
                let cTitle = task.title as! NSString
                let cDueDate = task.taskDueDate as! NSString
                let intStatus = task.status as! NSNumber
                
                sqlite3_bind_int(insertStatement, 1, Int32(task.user_id!))
                sqlite3_bind_text(insertStatement, 2, cTitle.utf8String, -1, nil)
                sqlite3_bind_int(insertStatement, 3, Int32(intStatus))
                sqlite3_bind_int(insertStatement, 4, Int32(task.priority!))
                sqlite3_bind_text(insertStatement, 5, cDueDate.utf8String, -1, nil)
                sqlite3_bind_int(insertStatement, 6, Int32(task.daysInAdvance!))
                
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    rowID = Int(sqlite3_last_insert_rowid(db))
                    print("Successfully inserted note into id: \(rowID)")
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
        
        return rowID
    }
    
    //MARK: Database functions for Notes
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
    
    func updateNote(note : Note) -> Bool {
        var db : OpaquePointer? = nil
        var returnCode = false
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            
            var updateStatement : OpaquePointer? = nil
            var updateQuery : String = "update Notes set Content = ? where Id = ?"
            
            if sqlite3_prepare_v2(db, updateQuery, -1, &updateStatement, nil) == SQLITE_OK {
                
                var cContent = note.content! as NSString
                
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
    
    func getNoteById(id: Int) -> Note {
        var note : Note = Note()
        
        var db : OpaquePointer? = nil
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            var selectStatement : OpaquePointer? = nil
            var selectQuery : String = "select * from Notes where Id = ?"
            
            if sqlite3_prepare_v2(db, selectQuery, -1, &selectStatement, nil) == SQLITE_OK {
                
                sqlite3_bind_int(selectStatement, 1, Int32(id))
                
                if sqlite3_step(selectStatement) == SQLITE_ROW {
                    let id : Int = Int(sqlite3_column_int(selectStatement, 0))
                    let cContent = sqlite3_column_text(selectStatement, 1)
                    let task_id : Int = Int(sqlite3_column_int(selectStatement, 2))
                    let duedate_id : Int = Int(sqlite3_column_int(selectStatement, 3))
                    let user_id : Int = Int(sqlite3_column_int(selectStatement, 4))
                    
                    let content = String(cString: cContent!)
                    
                    note = Note.init(row: id, content: content, task_id: task_id, duedate_id: duedate_id, user_id: user_id)
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
    
    func getNoteByDueDate(duedate_id: Int) -> Note? {
        var note : Note? = nil
        
        var db : OpaquePointer? = nil
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            var selectStatement : OpaquePointer? = nil
            var selectQuery : String = "select * from Notes where DueDate_Id = ?"
            
            if sqlite3_prepare_v2(db, selectQuery, -1, &selectStatement, nil) == SQLITE_OK {
                
                sqlite3_bind_int(selectStatement, 1, Int32(duedate_id))
                
                if sqlite3_step(selectStatement) == SQLITE_ROW {
                    let id : Int = Int(sqlite3_column_int(selectStatement, 0))
                    let cContent = sqlite3_column_text(selectStatement, 1)
                    let task_id : Int = Int(sqlite3_column_int(selectStatement, 2))
                    let duedate_id : Int = Int(sqlite3_column_int(selectStatement, 3))
                    let user_id : Int = Int(sqlite3_column_int(selectStatement, 4))
                    
                    let content = String(cString: cContent!)
                    
                    note = Note.init(row: id, content: content, task_id: task_id, duedate_id: duedate_id, user_id: user_id)
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
    
    func getNoteByTask(task_id : Int) -> Note? {
        var note : Note? = nil
        
        var db : OpaquePointer? = nil
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            var selectStatement : OpaquePointer? = nil
            var selectQuery : String = "select * from Notes where Task_Id = ?"
            
            if sqlite3_prepare_v2(db, selectQuery, -1, &selectStatement, nil) == SQLITE_OK {
                
                sqlite3_bind_int(selectStatement, 1, Int32(task_id))
                
                if sqlite3_step(selectStatement) == SQLITE_ROW {
                    let id : Int = Int(sqlite3_column_int(selectStatement, 0))
                    let cContent = sqlite3_column_text(selectStatement, 1)
                    let task_id : Int = Int(sqlite3_column_int(selectStatement, 2))
                    let duedate_id : Int = Int(sqlite3_column_int(selectStatement, 3))
                    let user_id : Int = Int(sqlite3_column_int(selectStatement, 4))
                    
                    let content = String(cString: cContent!)
                    
                    note = Note.init(row: id, content: content, task_id: task_id, duedate_id: duedate_id, user_id: user_id)
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

    //MARK: Database Functions for Contacts
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

    //MARK: Prepare Database
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

