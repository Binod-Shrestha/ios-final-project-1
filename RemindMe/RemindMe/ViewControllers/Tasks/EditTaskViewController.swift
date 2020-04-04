//
//  EditTaskViewController.swift
//  RemindMe
//
//  Created by Xcode User on 2020-03-29.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit

class EditTaskViewController: UIViewController {

    @IBOutlet var tfTitle : UITextField!
    @IBOutlet var sgmPriority : UISegmentedControl!
    @IBOutlet var swStatus : UISwitch!
    @IBOutlet var lbStatus : UILabel!
    @IBOutlet var btnNote : UIButton!
    @IBOutlet var btnUpdate : UIBarButtonItem!
    @IBOutlet var btnDelete : UIButton!
    
    @IBOutlet var dpDeadline :  UIDatePicker!
    
    @IBAction func btnDeleteClicked(sender: UIButton) {
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        var currentTask = mainDelegate.currentTask
        
        let alert = UIAlertController(title: "Confirmation", message: "Do you want to delete the task?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) {
            (action) in
            
            let returnCode = mainDelegate.deleteTask(id: currentTask!.id!)
            
            var title : String = ""
            var message : String = ""
            var action = UIAlertAction()
            
            if returnCode == true {
                // Successfully delete task
                title = "Successfully"
                message = "Deleted"
                action = UIAlertAction(title: "OK", style: .default) {
                    action in
                    self.performSegue(withIdentifier: "EditTaskToHomeSegue", sender: nil)
                }
            } else {
                // Delete task failed
                title = "Error"
                message = "Could not delete the task"
                action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            }
            
            var deleteAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            deleteAlert.addAction(action)
            
            self.present(deleteAlert, animated: true)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        
        self.present(alert, animated: true)
    }
    
    @IBAction func btnUpdateClicked(sender: UIBarButtonItem) {
        if tfTitle.text == "" || tfTitle.text == nil {
            var alert = UIAlertController(title: "Warning", message: "Please enter required field(s)!", preferredStyle: .alert)
            var cancelAction  = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Confirmation", message: "Do you want to update the task?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let confirmAction = UIAlertAction(title: "Confirm", style: .default) {
                (action) in
                
                let mainDelegate = UIApplication.shared.delegate as! AppDelegate
                var currentTask : Task? = mainDelegate.currentTask
                var note : Note?  =  currentTask?.note
                
                var title : String = ""
                var message : String = ""
                var action = UIAlertAction()
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
                var date = dateFormatter.string(from: self.dpDeadline.date)

                currentTask!.title = self.tfTitle.text
                currentTask!.status = self.swStatus.isOn
                currentTask!.priority = self.sgmPriority.selectedSegmentIndex
                currentTask!.taskDueDate = date
                currentTask!.daysInAdvance = 2
                currentTask!.note = note
                
                if note != nil {
                    let taskRowID = mainDelegate.insertTask(task: currentTask!)
                    if taskRowID != nil {
                        print("Inserted task")
                    } else {
                        print("Error insert task")
                    }
                } else {
                    let returnCode = mainDelegate.updateTask(task: currentTask!)
                    if returnCode == true {
                        // Successfully delete task
                        title = "Successfully"
                        message = "Updated"
                        action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    } else {
                        // Delete task failed
                        title = "Error"
                        message = "Could not update the task"
                        action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    }
                    
                    var deleteAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    deleteAlert.addAction(action)
                    
                    self.present(deleteAlert, animated: true)
                }
            }
            
            alert.addAction(cancelAction)
            alert.addAction(confirmAction)
            
            self.present(alert, animated: true)
        }
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
        
        if note == nil {
            // Create new note
            performSegue(withIdentifier: "EditTaskToCreateNoteSegue", sender: self)
        } else {
            // Update the note
            performSegue(withIdentifier: "EditTaskToEditNoteSegue", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        var currentTask = mainDelegate.currentTask
        
        tfTitle.text = currentTask!.title
        swStatus.isOn = currentTask!.status!
        if swStatus.isOn {
            lbStatus.text = "Active"
        } else {
            lbStatus.text = "Inactive"
        }
        sgmPriority.selectedSegmentIndex = currentTask!.priority!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let date = dateFormatter.date(from: currentTask!.taskDueDate!)
        dpDeadline.date = date!
        
        if currentTask!.note == nil {
            btnNote.setTitle("Add Note", for: .normal)
        } else {
            var tempNote = mainDelegate.currentTask!.note
            btnNote.setTitle("\u{2022} \(tempNote!.content!)", for: .normal)
            btnNote.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
