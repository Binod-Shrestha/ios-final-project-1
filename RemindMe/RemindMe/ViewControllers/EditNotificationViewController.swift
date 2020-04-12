//
//  EditNotificationViewController.swift
//  RemindMe
//  Binod Shrestha
//  Created by Xcode User on 2020-04-07.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit

class EditNotificationViewController: UIViewController {
    
    let notifyDate = UIDatePicker()
    var status = ""
    var returnMsg : String = ""
    @IBOutlet weak var tfnotifyDate: UITextField!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var statusSwitch: UISwitch!
    @IBOutlet weak var btnSave: UIBarButtonItem!
    var selectedDate: String!
    let dateFormatter = DateFormatter()
    
    //Mark: Notification status
    @IBAction func createStatus(_ sender: UISwitch) {
        if (statusSwitch.isOn) {
            status = "Enabled"
            lbStatus.text = "Notification is Enabled"
            lbStatus.textColor = .black
        }else{
            status = "Disabled"
            lbStatus.text = "Notification is Disabled"
            lbStatus.textColor = .red
        }
    }
    
    
    //MARK: update DueDate
    @IBAction func updateNotification(_ sender: Any)
    {
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        let currentNotification : Notification = mainDelegate.currentNotification!
       // var notifyDate = mainDelegate.currentNotification?.date
       // var notifyStatus = mainDelegate.currentNotification?.status
        
        if(tfnotifyDate.text == ""){
            createAlert(title: "Warning", message: "Please select the date.")
        }else if(status == ""){
            createAlert(title: "Warning", message: "Toggle the status")
        }else{
            let returnCode = mainDelegate.updateNotification(notification: currentNotification)
            var returnMsg:String="";
            if returnCode == true
            {
                 returnMsg  = "Notification updated"
            }
            else  if returnCode == false
            {
                 returnMsg = "Notification update Failed"
            }
            print(returnMsg)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        status = mainDelegate.currentNotification!.status!
        tfnotifyDate.text = mainDelegate.currentNotification?.date
        // Do any additional setup after loading the view.
    }
    
    //MARK: date function
    func createDatePicker()
    {
        //format date
        tfnotifyDate.textAlignment = .center
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        //done button for toobar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: true)
        tfnotifyDate.inputAccessoryView = toolbar
        tfnotifyDate.inputView = notifyDate
        
    }
    //MARK: done button for date picker
    @objc func donePressed()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .long
        self.tfnotifyDate.text = dateFormatter.string(from: notifyDate.date)
        self.view.endEditing(true)
        selectedDate = tfnotifyDate.text
    }
    
    //MARK: common alert function
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
