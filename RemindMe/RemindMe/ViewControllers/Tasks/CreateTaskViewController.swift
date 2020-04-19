//
//  CreateTaskViewController.swift
//  RemindMe
//
//  Created by Quynh Dinh on 2020-03-28.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit

class CreateTaskViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var tfTitle : UITextField!
    @IBOutlet var sgmPriority : UISegmentedControl!
    @IBOutlet var swStatus : UISwitch!
    @IBOutlet var lbStatus : UILabel!
    @IBOutlet var btnNote : UIButton!
    @IBOutlet var btnCreate : UIButton!
    
    @IBOutlet var dpDeadline :  UIDatePicker!
    
    // Create button event handler (user clicks button)
    @IBAction func btnCreateClicked(sender : UIButton) {
        // Check if the title is blank
        if tfTitle.text == "" || tfTitle.text == nil {
            var alert = UIAlertController(title: "Warning", message: "Please enter required field(s)!", preferredStyle: .alert)
            var cancelAction  = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            present(alert, animated: true)
        } else {
            // Create a new task
            let mainDelegate = UIApplication.shared.delegate as! AppDelegate

            var currentUser = mainDelegate.currentUser

            var currentTask : Task? = mainDelegate.currentTask
            var note : Note?  =  currentTask?.note
            
            var date : String?
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
            
            if swStatus.isOn {
                date = dateFormatter.string(from: dpDeadline.date)
            }

            currentTask = Task(user_id: currentUser!.id!, title: tfTitle.text!, status: swStatus.isOn, priority: sgmPriority.selectedSegmentIndex, taskDueDate: date, daysInAdvance: 3, note: note)
            mainDelegate.currentTask = currentTask
            
            var message : String = ""
            var title : String = ""
            var cancelAction = UIAlertAction()
            
            if (note?.id == nil && (note?.content == nil || note?.content == "")) {
                note = nil
            }
            
            // Check if the note is empty, create task that contains empty note
            if (note == nil) {
                currentTask!.note = note
                let taskReturnCode = mainDelegate.insertTask(task: currentTask!)
                if taskReturnCode {
                    title = "Successfully"
                    message = "Created \(currentTask!.title!)!"
                    cancelAction  = UIAlertAction(title: "OK", style: .cancel) {
                        action in
                        self.performSegue(withIdentifier: "UnwindFromCreateTaskToHomeVCSegue", sender: nil)
                    }
                } else {
                    title = "Error"
                    message = "Could not create \(currentTask!.title!). Please try again!"
                    cancelAction  = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                }
            } else {
                // Insert note before inserting task
                var note_id = mainDelegate.insertNote(note: note!)
                
                // Check if the note is created sucessfully
                // If yes, create new task
                // Otherwise, show an error alert
                if note_id != nil {
                    currentTask!.note!.id = note_id
                    let taskReturnCode = mainDelegate.insertTask(task: currentTask!)
                    if taskReturnCode {
                        title = "Successfully"
                        message = "Created \(currentTask!.title!)!"
                        cancelAction  = UIAlertAction(title: "OK", style: .cancel) {
                            action in
                            self.performSegue(withIdentifier: "UnwindFromCreateTaskToHomeVCSegue", sender: nil)
                        }
                    } else {
                        title = "Error"
                        message = "Could not create \(currentTask!.title!). Please try again!"
                        cancelAction  = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    }
                } else {
                    title = "Error"
                    message = "Could not create \(currentTask!.title!). Please try again!"
                    cancelAction  = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                }
            }
            
            var alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(cancelAction)
            present(alert, animated: true)
        }
    }
    
    // Switch Status Value Changed handler
    @IBAction func swStatusValueChanged(sender: UISwitch) {
        var status : String = ""
        if swStatus.isOn {
            dpDeadline.isEnabled = true
            status = "Active"
        } else {
            dpDeadline.isEnabled = false
            status = "Inactive"
        }
        lbStatus.text = status
    }
    
    // btnNote event handler
    @IBAction func btnNoteClicked(sender : UIButton) {
        // Get current state of the drafting task
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        var currentUser = mainDelegate.currentUser
        var currentTask : Task? = mainDelegate.currentTask
        var note : Note?  =  currentTask?.note

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        var date : String?
        if swStatus.isOn {
            date = dateFormatter.string(from: dpDeadline.date)
        }
        
        currentTask = Task(user_id: currentUser!.id!, title: tfTitle.text!, status: swStatus.isOn, priority: sgmPriority.selectedSegmentIndex, taskDueDate: date, daysInAdvance: 3, note: note)
        mainDelegate.currentTask = currentTask
        
        // Check if there is an existing note
        if note?.content == nil {
            // Create new note
            performSegue(withIdentifier: "CreateTaskToCreateNoteSegue", sender: self)
        } else {
            // Update the note
            performSegue(withIdentifier: "CreateTaskToEditNoteSegue", sender: self)
        }
    }
    
    // Unwind to this viewController from CreateNoteViewController
    @IBAction func unwindFromCreateNote(sender: UIStoryboardSegue) {}
    
    // Unwind to  this viewController from EditNoteViewController
    @IBAction func unwindFromEditNote(sender:UIStoryboardSegue) {}
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Set original data of the task before loading the view
    override func viewWillAppear(_ animated: Bool) {
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        var currentTask = mainDelegate.currentTask

        if currentTask != nil {
            tfTitle.text = currentTask!.title
            swStatus.isOn = currentTask!.status!
            sgmPriority.selectedSegmentIndex = currentTask!.priority!
            
            if swStatus.isOn {
                dpDeadline.isEnabled  = true
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
                let date = dateFormatter.date(from: currentTask!.taskDueDate!)
                dpDeadline.date = date!
            } else {
                dpDeadline.isEnabled = false
            }
            
            if currentTask?.note?.content == nil {
                btnNote.setTitle("Add Note", for: .normal)
            } else {
                var tempNote = mainDelegate.currentTask!.note
                btnNote.setTitle("\u{2022} " + tempNote!.content!, for: .normal)
            }
        } else {
            swStatus.isOn = true
            lbStatus.text = "Active"
        }
    }
}
