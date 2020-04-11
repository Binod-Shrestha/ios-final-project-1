//
//  EditViewController.swift
//  RemindMe
//  Binod Shrestha
//  Created by Xcode User on 2020-04-02.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit
import EventKit

class EditDueDateViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate {
    @IBOutlet weak var tfEventName: UITextField!
    @IBOutlet weak var pvCategory: UIPickerView!
    @IBOutlet weak var tfSCategory: UITextField!
    @IBOutlet weak var tfDueDate: UITextField!
    @IBOutlet weak var sgPriority: UISegmentedControl!
    @IBOutlet var btnNotification : UIButton!
    @IBOutlet var btnAlert : UIButton!
    
    var status : String?
    var selectedPriority : String?
    var selectedCategory : String?
    var selectedDate: String!
    var duedates:[DueDate] = []
    let datePicker = UIDatePicker()
    var pickerData = ["Business", "Personal", "School"]

    @IBOutlet weak var swReminders: UISwitch!
    
    // setReminders
    @IBAction func setNotification(_ sender: Any)
    {
        
    }
    
    // uiswitch for setting reminder
    @IBAction func setReminders(_ sender: Any)
    {
        let onState = swReminders.isOn
        if onState {
            status = "Active"
            btnNotification.isHidden = false
            btnAlert.isHidden = false
        }else{
            status = "Disabled"
            btnNotification.isHidden = true
            btnAlert.isHidden = true
        }
        
    }
    
    // segments function
    @IBAction func indexChanaged(_ sender: Any)
    {
        switch sgPriority.selectedSegmentIndex
        {
        case 0:
            selectedPriority = "High"
        case 1:
            selectedPriority = "Medium"
        case 2:
            selectedPriority = "Low"
        default:
            break
        }
    }

    // Update reminder
    func UpdateReminder()
    {
        let maindelegate = UIApplication.shared.delegate as! AppDelegate
        var eventStore = EKEventStore()
        let reminder = EKReminder(eventStore: eventStore)
        let reminderName = tfEventName.text!
        let reminderDate = tfDueDate.text!
        reminder.calendar = eventStore.defaultCalendarForNewReminders()!

        let reminderData : Reminder = Reminder(row: 0, reminderName: reminderName, reminderDate: reminderDate)
        let returnCode = maindelegate.updateReminder(reminder: reminderData)
    }

    //MARK: update DueDate
    @IBAction func updateDueDate(_ sender: Any)
    {
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        let currentUser : User = mainDelegate.currentUser!
        let currentDueDate : DueDate = mainDelegate.currentDueDate!
        var eventName = tfEventName.text!
        var sbCategory = tfSCategory.text!
        var dateFromDatabase = tfDueDate.text!
        
        //TODO: Update note and reminder
        let note : Note? = nil
        let reminder : Reminder? = nil
        currentDueDate.name = eventName
        currentDueDate.category = selectedCategory
        currentDueDate.subCategory =  sbCategory
        currentDueDate.date = dateFromDatabase
        currentDueDate.priority = selectedPriority
        currentDueDate.note = note
        currentDueDate.reminder = reminder
        
        
        
        //TODO: change insertDueDate to updateDueDate
        let returnCode = mainDelegate.updateDueDateData(duedate: currentDueDate)
        if returnCode == true
        {
            var returnMsg : String = "Due Date updated"

            if swReminders.isOn
            {
 
            	UpdateReminder() 
            }
        }
        else  if returnCode == false
        {
            var  returnMsg = "Due Date update Failed"
        }
    }
    
    // go away the keyboard after return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        createDatePicker()
        let duedate : DueDate = DueDate.init()
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        var currentDueDate = mainDelegate.currentDueDate
        
        tfEventName.text = currentDueDate!.name
        tfSCategory.text = currentDueDate!.subCategory
        tfDueDate.text = currentDueDate!.date
        selectedPriority = currentDueDate!.priority
        
        if (mainDelegate.currentDueDate!.priority == "High")
        {
           sgPriority.selectedSegmentIndex = 0
            
        } else if(mainDelegate.currentDueDate!.priority == "Medium"){
            sgPriority.selectedSegmentIndex = 1
            
        } else {
           sgPriority.selectedSegmentIndex = 2
            
        }

        // Date loaded from past duedate
        createDatePicker()
        // pickerview loaded from the past duedate
        
        var intSelectedCategory : Int? = pickerData.index(of: currentDueDate!.category!)
        selectedCategory = pickerData[intSelectedCategory!]
        
        self.pvCategory.selectRow(intSelectedCategory!, inComponent: 0, animated: true)
    }
    
    // pickerview
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = pickerData[row]
    }
    
    // date function
    func createDatePicker()
    {
        //format date
        tfDueDate.textAlignment = .center
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        //done button for toobar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: true)
        tfDueDate.inputAccessoryView = toolbar
        tfDueDate.inputView = datePicker
        
    }
    //MARK: done button for date picker
    @objc func donePressed()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .long
        self.tfDueDate.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
        selectedDate = tfDueDate.text
    }

}
