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
            
            if note != nil {
                let taskRowID = mainDelegate.insertTask(task: currentTask!)
                if taskRowID != nil {
                    print("Inserted task")
                } else {
                    print("Error insert task")
                }
            } else {
                let taskRowID = mainDelegate.insertTask(task: currentTask!)
                if taskRowID != nil {
                    print("Inserted task")
                    
                    //TODO: Add Note
                } else {
                    print("Error insert task")
                }
            }
            
            performSegue(withIdentifier: "CreateTaskToHomeSegue", sender: nil)
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
        
        if note == nil {
            // Create new note
            performSegue(withIdentifier: "CreateTaskToCreateNoteSegue", sender: self)
        } else {
            // Update the note
            performSegue(withIdentifier: "CreateTaskToEditNoteSegue", sender: self)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
            
            if currentTask?.note == nil {
                btnNote.setTitle("Add Note", for: .normal)
            } else {
                var tempNote = mainDelegate.currentTask!.note
                btnNote.setTitle("\u{2022} " + tempNote!.content!, for: .normal)
                btnNote.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            }
        } else {
            swStatus.isOn = true
            lbStatus.text = "Active"
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
