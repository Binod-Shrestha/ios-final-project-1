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
    @IBOutlet weak var swReminders : UISwitch!
    @IBOutlet weak var sgPriority: UISegmentedControl!
   
    var status : String?
    var selectedPriority : String?
    var selectedCategory : String?
    var selectedDate: String!
    var duedates:[DueDate] = []
    let datePicker = UIDatePicker()
    var pickerData = ["Business", "Personal", "School"]

    
    //MARK: ============ segments function by Binod ===================
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
           let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        let reminders = Reminder.init()
       //  let currentReminder : Reminder = mainDelegate.curentReminder!
        

        var eventStore = EKEventStore()
        let reminder = EKReminder(eventStore: eventStore)

         reminders.reminderName = tfEventName.text!
        
         reminders.reminderDate = tfDueDate.text
      
 
        reminder.calendar = eventStore.defaultCalendarForNewReminders()!

       
       let returnCode = mainDelegate.updateReminder(reminder:reminders)
        
       if returnCode == true{
	
       } else{
            
            print("Null")
       }
    }

    //MARK: ============ update DueDate by Binod ==================
    @IBAction func updateDueDate(_ sender: Any)
    {
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let currentDueDate : DueDate = mainDelegate.currentDueDate!
        let eventName = tfEventName.text!
        let sbCategory = tfSCategory.text!
        let dateFromDatabase = tfDueDate.text!
        
        currentDueDate.name = eventName
        currentDueDate.category = selectedCategory
        currentDueDate.subCategory =  sbCategory
        currentDueDate.date = dateFromDatabase
        currentDueDate.priority = selectedPriority
        
        
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
    
    //MARK: =========== By Binod Shrestha =========
    override func viewDidLoad()
    {
        super.viewDidLoad()

        createDatePicker()

        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        var currentDueDate = mainDelegate.currentDueDate
        ///var currentReminde = mainDelegate.curentReminder
        
    
        
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
    
    //MARK: =========== pickerview by Binod ====================
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
    
    //MARK: ============= date function by Binod =================
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
    //MARK: ========== done button for date picker by Binod ===============
    @objc func donePressed()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .long
        self.tfDueDate.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
        selectedDate = tfDueDate.text
    }
    
    
    @IBAction func unwindToEdittDueDateVC(sender:UIStoryboardSegue){
        self.loadView()
    }
    
    

}
