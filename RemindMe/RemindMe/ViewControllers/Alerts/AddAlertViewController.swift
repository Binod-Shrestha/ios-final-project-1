//
//  AddAlertViewController.swift
//  RemindMe
//
//  Created by Brian Holmes on 2020-04-09.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit
import UserNotifications

class AddAlertViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var dpTimePicker: UIDatePicker!
    @IBOutlet weak var tfAlertTextField : UITextField!
    @IBOutlet weak var btnSaveButton: UIBarButtonItem!
    @IBOutlet weak var btnCancelButton: UIBarButtonItem!
    
    @IBOutlet var lblCurrentAlertName : UILabel!
    @IBOutlet var lblCurrentAlertTime : UILabel!
    
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        print("Loading Alert Selector")
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tfAlertTextField.delegate = self
        
        //MARK: remove?
        //mainDelegate.currentAlert = nil
        if mainDelegate.currentAlert?.name != nil
        {
            tfAlertTextField.text = mainDelegate.currentAlert?.name
        }
        
        if mainDelegate.currentAlert?.time != nil{
            let timeInt : TimeInterval = Double(mainDelegate.currentAlert!.time)
            dpTimePicker.date = NSDate.init(timeIntervalSinceReferenceDate: timeInt) as Date
        }
        // set current date/time as the minimum date for picker
        //dpTimePicker.minimumDate = NSDate() as Date
        dpTimePicker.locale = NSLocale.current
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // Validation Checks
    func checkName() {
        // Disable the save button if the text field is empty
        let text = tfAlertTextField.text ?? ""
        //btnSaveButton.isEnabled = !text.isEmpty
    }
    func checkDate() {
        // Disable the save button if the date in the date picker has passed
        if NSDate().earlierDate(dpTimePicker.date) == dpTimePicker.date
        {
            btnSaveButton.isEnabled = false
        }
    }
    
    @IBAction func DoneClicked(sender: UIBarButtonItem){
        let name = tfAlertTextField.text ?? ""
        let timeFromIntervalToAlarm = Int(floor(dpTimePicker.date.timeIntervalSinceReferenceDate/60) * 60)
        
        // Send partial alert to mainDelegate to be added to alerts db on save of
        mainDelegate.newAlert = Alert.init(name: name, time: timeFromIntervalToAlarm)
        
        lblCurrentAlertName.text = mainDelegate.newAlert?.name
        lblCurrentAlertTime.text = mainDelegate.newAlert?.time.description
        //MARK: Add Segue to origin
        //performSegue(withIdentifier: "unwindToCreateDueDateVC", sender: nil)
        //mainDelegate.currentAlert = newAlert // Consider setting in insertToDb
    }
    
//
//    /////////////////////////////////////////
//    ////// MOVE THE BELOW TO DUEDATE VC /////
//    /////////////////////////////////////////
//    // For DueDate saveFunction
////    @IBAction func saveAlertToDbAndRegister(sender: UIButton) // Called when clicking SaveDueDate (before dueDate.db functions)
////    {
////        if mainDelegate.currentAlert?.alertID == nil {
////            // If dueDate has no currentAlert (only the case when creating a new dueDate, or updating a dueDate with no alert (adding and registering an Alert)
////            print("currentAlert?.alertID == nil")
////            //We are going to save a new alert
////
////
////
////
////            if ()
////            {
////
////            }
////            else
////            {
////
////            }
////        }
////        else
////        {
////            //There is currently an alert attached
////        }
////
////
////
////    }
//
//
//    // For DueDate saveFunction
//    @IBAction func saveAlertToDbAndRegister(sender: UIButton) // Called when clicking SaveDueDate (before dueDate.db functions)
//    {
//        lblCurrentAlertName.text = mainDelegate.newAlert?.name
//        lblCurrentAlertTime.text = mainDelegate.newAlert?.alertID?.description
//
//        if mainDelegate.currentAlert?.alertID == nil {
//            print("currentAlert?.alertID == nil")
//            // If dueDate has no currentAlert (only the case when creating a new dueDate, or updating a dueDate with no alert (adding and registering an Alert)
//            if mainDelegate.newAlert == nil {
//                print("newAlert = nil")
//                return
//            }else{ // We are creating a duedate, and we have a new alert
//                if mainDelegate.insertAlertIntoDatabase(alert: mainDelegate.newAlert!) == true{
//                    print("Alert saved to db")
//                    mainDelegate.currentAlert = mainDelegate.newAlert
//                    print("currentAlert = newAlert")
//                    //MARK: DueDate needs an 'Alert :Int' property
//                    //mainDelegate.currentDueDate.alert? = mainDelegate.currentAlert?.alertID
//
//                    //Schedule and register new alert
//                    scheduleNotification()
//                    print("scheduled notification")
//                    registerCategories()
//
//                   // mainDelegate.currentAlert = nil // clear currentAlert
//                    mainDelegate.newAlert = nil // clear newAlert
//                }else{
//                    print("Alert not saved to db")
//                }
//            }
//        }else{// If dueDate HAS a currentAlert (only the case when editing a dueDate (updating db unregistering previous alert and registering new Alert)
//            print("currentAlert?.alertID != nil")
//            // MARK: Logic for editing dueDate that had an Alert
//            if mainDelegate.newAlert == nil {
//                print("newAlert == nil")
//                return
//            }else{
//                if mainDelegate.insertAlertIntoDatabase(alert: mainDelegate.newAlert!) == true{
//                    print("Alert saved to db")
//
//                   // unscheduleNotification(mainDelegate.currentAlert.alertID)
//
//                    mainDelegate.currentAlert = mainDelegate.newAlert
//                    //MARK: DueDate needs an 'Alert :Int' property
//                    //mainDelegate.currentDueDate.alert? = mainDelegate.currentAlert?.alertID
//
//                    //Schedule and register new alert
//                    scheduleNotification()
//                    registerCategories()
//
//                    mainDelegate.currentAlert = nil // clear currentAlert
//                    mainDelegate.newAlert = nil // clear newAlert
//                }else{
//                    print("Alert not saved to db")
//                }
//            }
//        }
//    }
//
//
//
//    func scheduleNotification(){
//
//        let alertIdNumberForIdent = mainDelegate.currentAlert?.alertID! as! NSNumber
//        let alertIdStringForIdent = alertIdNumberForIdent.stringValue
//
////        let name = tfAlertTextField.text ?? ""
//        let center = UNUserNotificationCenter.current()
//        let content = UNMutableNotificationContent()
//        content.title = "Alert for:  \(String(describing: mainDelegate.currentDueDate))"
//        content.body = "Alert note: \(String(describing: mainDelegate.currentAlert?.name))"
//        content.categoryIdentifier = "alarm"
//        //content.userInfo = ["custom  data" : "fizzbuzz"]
//        content.sound = UNNotificationSound.default
//
//        // current time
//        let now = Date()
//
//        // ensure trigger time is on the minute
//        let timeFromIntervalToAlarm = mainDelegate.currentAlert?.time
//        let timeFromintervalToCurrent = Int(floor(now.timeIntervalSinceReferenceDate/60) * 60)
//        let intervalFromCurrentToAlarm = timeFromIntervalToAlarm! - timeFromintervalToCurrent
//
//        //Sets trigger
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(intervalFromCurrentToAlarm), repeats: false)
//
//        // (FOR TESTING) Show alert 10 seconds after being scheduled
//        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
//
//
//        // Builds UNNotification Request
//        let request = UNNotificationRequest(identifier: alertIdStringForIdent, content: content, trigger: trigger)
//        //Adding request to notification center
//        center.add(request)
//    }
//
////    func unscheduleNotification(int : Int){
////        //MARK: Unscheduling array
////        let alertIdNumberForIdent = mainDelegate.currentAlert?.alertID! as! NSNumber
////        let alertIdStringForIdent = alertIdNumberForIdent.stringValue as NSString
//////        let rA = [NSArray, arrayWithObjects: objects: alertIdStringForIdent count: 1)
//////
//////        let requestsArray: NSArray = [alertIdStringForIdent]
//////
//////        let center = UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: requestsArray)
//////
//////        let removal = UNNotificationRequest.removePendingNotificationRequestsWithIdentifier();
////
////    }
//
//    func registerCategories(){
//        let center = UNUserNotificationCenter.current()
//        center.delegate = self as? UNUserNotificationCenterDelegate
//
//        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
//        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])
//
//        center.setNotificationCategories([category])
//    }
//
//
//    // schedule delivery
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didRecieve response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void){
//
//        // pull out buried userInfo dictionary
//
//        let userInfo = response.notification.request.content.userInfo
//
//        if let customData = userInfo["customData"] as? String {
//
//            print("Custom data recieved; \(customData)")
//
//            switch response.actionIdentifier {
//            case UNNotificationDefaultActionIdentifier:
//                // the user swiped to unlock
//                print("Default identifier")
//
//            case "show":
//                // the user tapped the "Tell me more..." button
//                break
//            default:
//                break
//
//            }
//        }
//        completionHandler()
//    }
//
//    //////////////////////////////////////
//    ////////// END OF MOVE ///////////////
//    /////////////////////////////////////
//

    // Textfield validation
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkName()
        navigationItem.title = textField.text
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
       // btnSaveButton.isEnabled = false
    }
    // DatePicker validation
    @IBAction func timeChanged(sender: UIDatePicker){
        checkDate()
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        /*
        if saveButton === sender as? UIBarButtonItem {
            let name = alertTextField.text
            var time = timePicker.date
            
            // ensure trigger time is on the minute
            var timeInterval = floor(time.timeIntervalSinceReferenceDate/60) * 60
            time = NSDate(timeIntervalSinceReferenceDate: timeInterval) as Date
           */
            
    
            /*
            // build notification
            let notification = UNNotificationRequest()
            notification.alertTitle = "Alert"
            notification.alertBody  = "\(String(describing: name))"
            notification.fireDate  = time
            notification.soundName = UILocalNotificationDefaultSoundName
            
            UIApplication.shared.scheduleLocalNotification(notification)
            let alert = Alert(name: name!, time: time as NSDate, notification: notification)
            
            */
        }
    
}
