//
//  CreateNotificationViewController.swift
//  RemindMe
//  Binod Shrestha
//  Created by Xcode User on 2020-04-07.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit
import UserNotifications

class CreateNotificationViewController: UIViewController {
    
    @IBOutlet weak var notifyDate: UIDatePicker!
    var status = ""
    var returnMsg : String = ""
    @IBOutlet weak var tfnotifyDate: UITextField!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var statusSwitch: UISwitch!
    @IBOutlet weak var btnSave: UIBarButtonItem!
     let dateFormatter = DateFormatter()
    
    //MARK: Switch function
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
    
    
    //MARK: alert function
    func setNotification(date : Date) {
        let duedate : DueDate = DueDate.init()
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
      //  var currentUser : User = mainDelegate.currentUser!
    
        //calculating remaining days:
        let strDate:String = tfnotifyDate.text!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MMMM-dd"
        let calendar = Calendar.current
        var now = Date()
         let dueDay = dateFormatter.date(from: strDate)
        
        dateFormatter.dateFormat = "yyyy-MMMM-dd HH:mm:ss z"
        let Enddate = dateFormatter.date(from: strDate)
        
        let date1 = calendar.startOfDay(for: now)
        let date2 = calendar.startOfDay(for: Enddate!)
        let remainingDay = calendar.dateComponents([.day], from: date1, to: date2).day!
        
        // Step 1: Ask for permission
        let center = UNUserNotificationCenter.current()
         let content = UNMutableNotificationContent()
         UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge ], completionHandler: {didAllow, error in })
         
         // Step 2: Create the notification content
         //content.title = "mainDelegate.duedates[currentUser.id!].name!"
         //content.body = "\(mainDelegate.duedates[currentUser.id].name!) is \(remainingDay) day(s) away."
        content.title = "This is a reminder."
        content.body = "Your assignment is \(remainingDay) day(s) away."
         content.sound = .default
         
         // Step 3: Create the notification trigger
         let calander = Calendar(identifier: .gregorian)
         let components = calander.dateComponents(in: .current, from: date)
         let newComponents = DateComponents(calendar: calander, timeZone: .current,  month: components.month, day: components.day, hour: components.hour, minute: components.minute)
         let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
         
         // Step 4: Create the request
         let request = UNNotificationRequest(identifier: "Reminder", content: content, trigger: trigger)
         UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
         
         // Step 5: Register the request
         center.add(request) { (error) in
         if error != nil{
         print("Error = \(error?.localizedDescription ?? "error local notification")")
         }
         UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge ], completionHandler: {didAllow, error in })
         }
    }
    //MARK: save notification function
    @IBAction func saveNotification(_ sender: Any) {
        let notification : Notification = Notification.init()
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        if (tfnotifyDate.text == ""){
            createAlert(title: "Warning", message: "Please select the date.")
        }else if(status == ""){
            createAlert(title: "Warning", message: "Please toggle the status")
        }else{
            
            notifyDate.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
            let strDate:String = tfnotifyDate.text!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MMMM-dd HH:mm:ss z"
            let date = dateFormatter.date(from: strDate)
            print(date)
    
            notification.initWithData(theRow: 0, theStatus: status, theDate: tfnotifyDate.text!)
            
            setNotification(date: date!)
            
            let returnCode = mainDelegate.insertNotificationIntoDatabase(notification: notification)
            var returnMsg : String = ""
            if returnCode == true
            {
                returnMsg = "Notification Added"
                print(returnMsg)
               performSegue(withIdentifier: "CreateDueDateToHomeVCSegue", sender: self)
            }
            else  if returnCode == false
            {
                returnMsg = "Notification Add Failed"
                print(returnMsg)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dateFormatter.dateFormat = "yyyy-MMMM-dd HH:mm:ss zz"
        tfnotifyDate.inputView = notifyDate
        notifyDate.datePickerMode = .dateAndTime
        tfnotifyDate.text = dateFormatter.string(from: notifyDate.date)
        statusSwitch.isSelected = true
        lbStatus.text = "Notification is Enabled"
    
    }
    
    //MARK: Date function
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        
        tfnotifyDate.text = dateFormatter.string(from: sender.date)
        view.endEditing(true)
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
