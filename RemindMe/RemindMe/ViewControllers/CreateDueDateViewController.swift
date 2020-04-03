//
//  pickerViewController.swift
//  RemindMe
//
//  Created by Xcode User on 2020-03-24.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit

class CreateDueDateViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate {
   
    @IBOutlet weak var ntes: UITextField!
    @IBOutlet var tfEventTitle : UITextField!
   
    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet weak var btnAlert: UIButton!
    
    @IBOutlet weak var btnNotification: UIButton!
    
    @IBOutlet weak var AlarmNotificationTblVW: UITableView!
    @IBOutlet weak var notesTextArea: UITextView!
    @IBOutlet weak var reminderSwitch: UISwitch!
  
    
    @IBOutlet weak var alarmNotification: UITableView!
    
    //for date
    let datePicker = UIDatePicker()
    var pickerData: [String] = [String]()
    @IBOutlet weak var duedatesTable: UITableView!
    let cellReuseIdentifier = "cell"
    var duedates:[DueDate] = []
    

    @IBOutlet weak var tfsubCategory : UITextField!
    @IBOutlet weak var lbPickerView: UILabel!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var prioritySC: UISegmentedControl!
    @IBOutlet weak var lblPriority: UILabel!
    
    // variables to hold selected value from UI
    var status: String!
    var selectedDate: String!
    var selectedCategory: String!
    var selectedPriority: String!
    
    
    
    //alert function
    
    @IBAction func setAlert(_ sender: Any) {
    }
    
    //notification function
    
    @IBAction func setNotification(_ sender: Any) {
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
    
    @IBAction func insertDueDate(_ sender: Any) {
        
        let duedate : DueDate = DueDate.init()
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        
        var currentUser : User = mainDelegate.currentUser!
        
        // TODO: Update note and reminder
        var note : Note? = nil
        var reminder : Reminder? = nil
        
        duedate.initWithData(theRow: 0, theUserId: currentUser.id!, theName: tfEventTitle.text!, theCategory: selectedCategory, theSubCategory: tfsubCategory.text!, theDate: selectedDate, thePriority: selectedPriority, theNote: note, theReminder: reminder)
        
        let returnCode = mainDelegate.insertDueDateIntoDatabase(duedate: duedate)
        
        if returnCode == true
        {
            var returnMsg : String = "Due Date Added"
            performSegue(withIdentifier: "CreateDueDateToHomeVCSegue", sender: self)
        }
            
        else  if returnCode == false
        {
            var  returnMsg = "Due Date Add Failed"
           //performSegue(withIdentifier: "dueDateSegue", sender: self)
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        //call method for done
        createDatePicker()
        pickerData = ["Business", "Personal", "School"]

        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func createDatePicker(){
        //format date
        dateTextField.textAlignment = .center
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        //done button for toobar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: true)
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
        
    }
    @objc func donePressed(){
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .long
            self.dateTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
        selectedDate = dateTextField.text
        
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
