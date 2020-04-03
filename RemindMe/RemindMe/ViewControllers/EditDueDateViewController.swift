//
//  EditViewController.swift
//  RemindMe
//
//  Created by Xcode User on 2020-04-02.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit

class EditDueDateViewController: UIViewController {

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
    var pickerData: [String] = [String]()
    let datePicker = UIDatePicker()

    
    @IBOutlet weak var swReminders: UISwitch!
    // setReminders
    @IBAction func setNotification(_ sender: Any) {
    }
    // uiswitch for setting reminder
    @IBAction func setReminders(_ sender: Any) {
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
    @IBAction func indexChanaged(_ sender: Any) {
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

    @IBAction func insertDueDate(_ sender: Any) {
        
        let duedate : DueDate = DueDate.init()
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        
        var currentUser : User = mainDelegate.currentUser!
        
        // TODO: Update note and reminder
        var note : Note? = nil
        var reminder : Reminder? = nil
        
        duedate.initWithData(theRow: 0, theUserId: currentUser.id!, theName: tfEventName.text!, theCategory: selectedCategory!, theSubCategory: tfSCategory.text!, theDate: selectedDate, thePriority: selectedPriority!, theNote: note, theReminder: reminder)
        
        let returnCode = mainDelegate.insertDueDateIntoDatabase(duedate: duedate)
        
        if returnCode == true
            
        {        var returnMsg : String = "Due Date Added"
            performSegue(withIdentifier: "VCDueDateSegue", sender: self)
            print("HI")
        }
            
        else  if returnCode == false
        {
            var  returnMsg = "Due Date Add Failed"
            //performSegue(withIdentifier: "dueDateSegue", sender: self)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    // date function
    func createDatePicker(){
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
    @objc func donePressed(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .long
        self.tfDueDate.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
        selectedDate = tfDueDate.text
        
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
