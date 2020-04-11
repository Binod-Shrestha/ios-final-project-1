//
//  pickerViewController.swift
//  RemindMe
//  Binod Shrestha
//  Created by Xcode User on 2020-03-24.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit
import UserNotifications

class CreateDueDateViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate {
    @IBOutlet var tfEventTitle : UITextField!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var btnAlert: UIButton!
    @IBOutlet weak var btnNotification: UIButton!
    @IBOutlet weak var reminderSwitch: UISwitch!
  
    //for date
    let datePicker = UIDatePicker()
    var pickerData: [String] = [String]()
    let cellReuseIdentifier = "cell"
    var duedates:[DueDate] = []
    @IBOutlet weak var tfsubCategory : UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var prioritySC: UISegmentedControl!
    
    // variables to hold selected value from UI
    var status: String!
    var selectedDate: String!
    var selectedCategory: String!
    var selectedPriority: String!
    
    @IBAction func unwindToCreateDueDateVC(sender:UIStoryboardSegue){
        
    }
  
    // uiswitch for setting reminder
    @IBAction func setReminders(_ sender: Any) {
        let onState = reminderSwitch.isOn
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
    //MARK: save dueDate
    @IBAction func insertDueDate(_ sender: Any) {
        
        let duedate : DueDate = DueDate.init()
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        let currentUser : User = mainDelegate.currentUser!
        
        // TODO: Update note and reminder
        let note : Note? = nil
        let reminder : Reminder? = nil
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
            duedate.initWithData(theRow: 0, theUserId: currentUser.id!, theName: tfEventTitle.text!, theCategory: selectedCategory, theSubCategory: tfsubCategory.text!, theDate: selectedDate, thePriority: selectedPriority, theNote: note, theReminder: reminder)
            
            let returnCode = mainDelegate.insertDueDateIntoDatabase(duedate: duedate)
            var returnMsg:String=""
            if returnCode == true
            {
                 returnMsg = "Due Date Added"
                performSegue(withIdentifier: "CreateDueDateToHomeVCSegue", sender: self)
            }
            else  if returnCode == false
            {
                returnMsg = "Due Date Add Failed"
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
    
    // pickerview
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

    //table view of due details
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return duedates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)!
        return cell
    }
    //MARK: create date
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
    
    //MARK: date selection
    @objc func donePressed(){
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .long
            self.dateTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
        selectedDate = dateTextField.text
    }
    
    //MARK: Alert function
    func createAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present (alertController, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
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
