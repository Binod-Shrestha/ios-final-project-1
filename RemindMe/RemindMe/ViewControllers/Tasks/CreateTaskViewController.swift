//
//  CreateTaskViewController.swift
//  RemindMe
//
//  Created by Xcode User on 2020-03-28.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit

class CreateTaskViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var tfTitle : UITextField!
    @IBOutlet var sgmPriority : UISegmentedControl!
    @IBOutlet var swStatus : UISwitch!
    @IBOutlet var lbStatus : UILabel!
    @IBOutlet var btnNote : UIButton!
    @IBOutlet var btnCreate : UIBarButtonItem!
    
    @IBOutlet var dpDeadline :  UIDatePicker!
    
    @IBAction func btnCreateClicked(sender : UIBarButtonItem) {
        if tfTitle.text == "" || tfTitle.text == nil {
            var alert = UIAlertController(title: "Warning", message: "Please enter required field(s)!", preferredStyle: .alert)
            var cancelAction  = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            present(alert, animated: true)
        } else {
            let mainDelegate = UIApplication.shared.delegate as! AppDelegate

            var currentUser = mainDelegate.currentUser

            var currentTask : Task? = mainDelegate.currentTask
            var note : Note?  =  currentTask?.note
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
            var date = dateFormatter.string(from: dpDeadline.date)
            
            currentTask = Task(user_id: currentUser!.id!, title: tfTitle.text!, status: swStatus.isOn, priority: sgmPriority.selectedSegmentIndex, taskDueDate: date, daysInAdvance: 3, note: note)
            mainDelegate.currentTask = currentTask
            
            //TODO: Add Alert
            var message : String = ""
            var title : String = ""
            var cancelAction = UIAlertAction()
            
            if (note?.id == nil && (note?.content == nil || note?.content == "")) {
                note = nil
            }
            
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
                var note_id = mainDelegate.insertNote(note: note!)
                
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
    
    @IBAction func swStatusValueChanged(sender: UISwitch) {
        var status : String = ""
        if swStatus.isOn {
            status = "Active"
        } else {
            status = "Inactive"
        }
        lbStatus.text = status
    }
    
    @IBAction func btnNoteClicked(sender : UIButton) {
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        var currentUser = mainDelegate.currentUser
        var currentTask : Task? = mainDelegate.currentTask
        var note : Note?  =  currentTask?.note

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        var date = dateFormatter.string(from: dpDeadline.date)
        
        currentTask = Task(user_id: currentUser!.id!, title: tfTitle.text!, status: swStatus.isOn, priority: sgmPriority.selectedSegmentIndex, taskDueDate: date, daysInAdvance: 3, note: note)
        mainDelegate.currentTask = currentTask
        
        if note?.content == nil {
            // Create new note
            performSegue(withIdentifier: "CreateTaskToCreateNoteSegue", sender: self)
        } else {
            // Update the note
            performSegue(withIdentifier: "CreateTaskToEditNoteSegue", sender: self)
        }
    }
    
    @IBAction func unwindFromCreateNote(sender: UIStoryboardSegue) {}
    
    @IBAction func unwindFromEditNote(sender:UIStoryboardSegue) {}
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        var currentTask = mainDelegate.currentTask
        
        // Set up task info
        if currentTask != nil {
            tfTitle.text = currentTask!.title
            swStatus.isOn = currentTask!.status!
            sgmPriority.selectedSegmentIndex = currentTask!.priority!
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
            let date = dateFormatter.date(from: currentTask!.taskDueDate!)
            
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
