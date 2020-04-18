//
//  pickerViewController.swift
//  RemindMe
//  Binod Shrestha
//  Created by Xcode User on 2020-03-24.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit
import UserNotifications
import EventKit

class CreateDueDateViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate {
    @IBOutlet var tfEventTitle : UITextField!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var btnNotification: UIButton!
    @IBOutlet weak var reminderSwitch: UISwitch!


    //MARK: =============== Save Due Date  by Binod ==================
    @IBAction func saveDueDate(_ sender: Any) {
       insertDueDate()
        createAlert(title: "Information", message: "Due Date added successfully.")
        
    }

    //Mark: ========= add notification by Binod ===========
    @IBAction func addNotification(_ sender: Any) {
        
        saveNotification()
    }
    
    //MARK: ============= save notification by Binod =============
     func saveNotification() {
       
        let alertController = UIAlertController(title: "Information", message: "Do you want to add notification to the due date ?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let okAction = UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.insertDueDate()
            self.performSegue(withIdentifier: "CreateDueDateToCreateNotificationVCSegue", sender: self)
        })
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController,animated: true, completion: nil)
        
    }

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    //MARK: ========= for date by Binod ===================
    let datePicker = UIDatePicker()
    var pickerData: [String] = [String]()
    let cellReuseIdentifier = "cell"
    var duedates:[DueDate] = []
    var duedate : DueDate = DueDate()

    let eventStore = EKEventStore()
    var calendars: [EKCalendar] =  [EKCalendar]()

    @IBOutlet weak var tfsubCategory : UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var prioritySC: UISegmentedControl!
    
    // variables to hold selected value from UI
    var status: String!
    var selectedDate: String!
    var selectedCategory: String!
    var selectedPriority: String!
    
    
    //Sherwin : Function will create a reminder
    func createReminder()
    {
        var eventStore = EKEventStore()
        
        self.eventStore.requestAccess(to: EKEntityType.reminder, completion: {
            (isAllowed, error) in
            if isAllowed {
                print("Access to Reminders is granted")
            } else {
                print("Access to Reminders is not granted")
                print(error?.localizedDescription)
            }
        })
        
        if eventStore != nil {
            let reminder = EKReminder(eventStore: eventStore)
            reminder.title = tfEventTitle.text
            reminder.calendar = eventStore.defaultCalendarForNewReminders()!

            let date = datePicker.date
            
            let alarm = EKAlarm(absoluteDate: date)
            reminder.addAlarm(alarm)
            
            let mainDelegate = UIApplication.shared.delegate as! AppDelegate
            let reminderData : Reminder = Reminder(row: 0, reminderName: reminder.title, reminderDate: selectedDate)
            let returnCode = mainDelegate.insertReminder(reminder: reminderData)
            
            do {
                try eventStore.save(reminder, commit: true)
            } catch let error {
                print("Reminder failed with error \(error.localizedDescription)")
            }
        } else {
            print("Could not create reminder")
        }
    }
    
    //MARK: ----------------- segments function-----By Binod---------------
    @IBAction func indexChanaged(_ sender: Any) {
        switch prioritySC.selectedSegmentIndex
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
    //MARK: ----------------save dueDate By Binod -------------------------
     func insertDueDate() {
        duedate = DueDate.init()
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        let currentUser : User = mainDelegate.currentUser!
        
        if(tfEventTitle.text! == ""){
            createAlert(title: "Warning", message: "Please fill in the due date title")
        } else if (selectedCategory == nil){
            createAlert(title: "Warning", message: "Please select a category.")
        } else if(selectedDate == nil){
            createAlert(title: "Warning", message: "Please select due date.")
        }else if(selectedPriority == nil){
            createAlert(title: "Warning", message: "Please select the priority.")
        }
        else{
            duedate.initWithData(theRow: 0, theUserId: currentUser.id!, theName: tfEventTitle.text!, theCategory: selectedCategory, theSubCategory: tfsubCategory.text!, theDate: selectedDate, thePriority: selectedPriority, theAlert: appDelegate.notification.id)
            
            let returnCode = mainDelegate.insertDueDateIntoDatabase(duedate: duedate)
            
            var returnMsg:String=""
            if returnCode == true
            {
                if reminderSwitch.isOn{
                    
                    //Sherwin : Function will be called only if the switch is on 
                    self.createReminder()
                }
                
                 returnMsg = "Due Date Added"
            }
            else  if returnCode == false
            {
                returnMsg = "Due Date Add Failed"
                createAlert(title: "Warning", message: "Due Date added failed.")
            }
            print(returnMsg)
        }
    }
  
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //call method for done
        pickerData = ["Business", "Personal", "School"]

        createDatePicker()
        

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:------------------- pickerview-----------------By Binod----------------------
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
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
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        selectedCategory = pickerData[row]
    }

    //MARK:---------------table view of due details---------By Binod
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return duedates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)!
        return cell
    }
    //MARK: ------------create date-----------By Binod----------------------
    func createDatePicker(){
        //format date
        dateTextField.textAlignment = .center
        if(dateTextField.text == ""){createAlert(title: "Warning", message: "Please select a date!")}
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //done button for toobar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: true)
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
        
    }
    
    //MARK: -----------------------date selection by Binod ---------------------------
    @objc func donePressed(){
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .long
            self.dateTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
        selectedDate = dateTextField.text
    }
    
    //MARK: -----------------------Alert function by Binod---------------------------
    func createAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present (alertController, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    @IBAction func unwindToCreateDueDateVC(sender:UIStoryboardSegue){
        self.loadView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CreateNotificationViewController{
            destination.text = tfEventTitle.text!
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
