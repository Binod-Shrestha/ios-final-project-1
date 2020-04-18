//
//  CreateNotificationViewController.swift
//  RemindMe
//  Binod Shrestha and Brian
//  Created by Xcode User on 2020-04-07.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit
import UserNotifications
//MARK:===================== BY BINOD AND BRIAN ==========================
class CreateNotificationViewController: UIViewController {
    
    @IBOutlet weak var notifyDate: UIDatePicker!
    var status = ""
    var returnMsg : String = ""
    @IBOutlet weak var tfnotifyDate: UITextField!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var statusSwitch: UISwitch!
    @IBOutlet weak var btnSave: UIBarButtonItem!
     let dateFormatter = DateFormatter()
    var text: String = ""
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var currentEventName: UILabel!
    
    @IBOutlet weak var setNotifyingDate: UILabel!
    
    @IBOutlet weak var currentStatus: UILabel!
    
    //MARK: ================Switch function: By Binod=============
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
    
    
    //MARK: =============== alert function By Binod and Brian ====================
    func setNotification(date : Date) {
      //  var currentUser : User = mainDelegate.currentUser!
    
        //calculating remaining days:
        let strDate:String = tfnotifyDate.text!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MMMM-dd"
        let calendar = Calendar.current
        let now = Date()
        
        dateFormatter.dateFormat = "yyyy-MMMM-dd HH:mm:ss z"
        let Enddate = dateFormatter.date(from: strDate)
        
        let date1 = calendar.startOfDay(for: now)
        let date2 = calendar.startOfDay(for: Enddate!)
        let remainingDay = calendar.dateComponents([.day], from: date1, to: date2).day!
        
        // Step 1: Ask for permission
        let center = UNUserNotificationCenter.current()
         let content = UNMutableNotificationContent()
         UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge ], completionHandler: {didAllow, error in })
        
        
        content.title = text
        content.body = "\(text) is \(remainingDay) day(s) away."
        content.categoryIdentifier = "alarm"
         content.sound = .default
         
         // Step 3: Create the notification trigger
         let calander = Calendar(identifier: .gregorian)
         let components = calander.dateComponents(in: .current, from: date)
         let newComponents = DateComponents(calendar: calander, timeZone: .current,  month: components.month, day: components.day, hour: components.hour, minute: components.minute)
         let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
         
         // Step 4: Create the request
         let request = UNNotificationRequest(identifier: "Reminder", content: content, trigger: trigger)
         //UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
         
         // Step 5: Register the request
         center.add(request)
         { (error) in
         if error != nil{
         print("Error = \(error?.localizedDescription ?? "error local notification")")
         }
         }
    }
    
    func  registerCategories(){
        let center = UNUserNotificationCenter.current()
        center.delegate = self as? UNUserNotificationCenterDelegate
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])
        center.setNotificationCategories([category])
    }
    
    //MARK: ============= save notification function By: Binod =================
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
            registerCategories()
            
            let returnCode = mainDelegate.insertNotificationIntoDatabase(notification: notification)
            
            //labels for recent notification
            currentEventName.text = text
            currentStatus.text = status
            setNotifyingDate.text = strDate
            
            
            var returnMsg : String = ""
            if returnCode == true
            {
                returnMsg = "Notification Added"
                print(returnMsg)
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
        statusSwitch.isSelected = false
        lbStatus.text = "Notification is disabled"
        
        self.dismiss(animated: true, completion: nil)
    
    }
    
    //MARK: ============== Date function By Binod ===================
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        
        tfnotifyDate.text = dateFormatter.string(from: sender.date)
        view.endEditing(true)
    }
    
    //MARK: =========common alert function by Binod==================
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
