//
//  AlertsTableViewController.swift
//  RemindMe
//
//  Created by Xcode User on 2020-04-09.
//  Copyright © 2020 BBQS. All rights reserved.
//
/*
import UIKit

class AlertsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    // Properties
    //var alerts = [Alert]()
    let dateFormatter = DateFormatter()
    let locale = NSLocale.current
    //TODO: populate alert from mainDelegate
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let backgroundImage = UIImage(named: "lite.jpg")
        
        //Remove extra empty cells from view
        let imageView = UIImageView(image: backgroundImage)
        
        tableView.backgroundView = imageView
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        imageView.contentMode = .scaleAspectFit
        
        mainDelegate.getContactsByUserId()
        
        cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ContactCell ?? ContactCell(style: .default, reuseIdentifier: "cell")
        
        // Populate cell
        let row = indexPath.row
        
        
        (cell as! ContactCell).nameLabel.text = mainDelegate.contacts[row].name
        (cell as! ContactCell).organizationLabel.text = mainDelegate.contacts[row].organization
        (cell as! ContactCell).phoneLabel.text = mainDelegate.contacts[row].phone
        (cell as! ContactCell).emailLabel.text = mainDelegate.contacts[row].email
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //TDOD: Set more dateFormatter settings
        dateFormatter.locale = locale
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        
        
        // load alerts
        
        //if let savedAlerts = loadAlerts() {
          //  alerts += savedAlerts
       // }
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






//MARK : OLD TableViewController::

/*
 
 import UIKit
 
 class AlertsTableViewController(wrongone): UITableViewController {
 
 // Properties
 var alerts = [Alert]()
 let dateFormatter = DateFormatter()
 let locale = NSLocale.current
 //TODO: populate alert from mainDelegate
 let alert: Alert = Alert(name: String(), time: NSDate(), notification: UILocalNotification());
 
 
 override func viewDidLoad() {
 super.viewDidLoad()
 // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
 // self.navigationItem.rightBarButtonItem = self.editButtonItem
 
 //TDOD: Set more dateFormatter settings
 dateFormatter.locale = locale
 dateFormatter.dateStyle = .medium
 dateFormatter.timeStyle = .short
 
 // load alerts
 
 if let savedAlerts = loadAlerts() {
 alerts += savedAlerts
 }
 
 }
 
 // MARK: - Table view data source
 
 override func numberOfSections(in tableView: UITableView) -> Int {
 // #warning Incomplete implementation, return the number of sections
 return 1
 }
 
 override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 // #warning Incomplete implementation, return the number of rows
 return alerts.count
 }
 
 
 override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 let cell = tableView.dequeueReusableCell(withIdentifier: "alertCell", for: indexPath)
 
 // Configure the cell...
 let alert = alerts[indexPath.row]
 cell.textLabel?.text = alert.name
 cell.detailTextLabel?.text = "Due " + dateFormatter.string(from: alert.time as Date)
 
 return cell
 }
 
 
 /*
 // Override to support conditional editing of the table view.
 override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
 // Return false if you do not want the specified item to be editable.
 return true
 }
 */
 
 
 // Override to support editing the table view.
 override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
 if editingStyle == .delete {
 let toRemove = alerts.remove(at: indexPath.row)
 //TODO: Check this call
 // toRemove.delete(self)
 // toRemove.release()
 // Delete the row from the data source
 tableView.deleteRows(at: [indexPath], with: .fade)
 
 saveAlerts()
 }
 }
 
 @IBAction func unwindToAlertList(sender: UIStoryboardSegue){
 
 let newIndexPath = NSIndexPath(row: alerts.count, section: 0)
 alerts.append(alert)
 tableView.insertRows(at: [newIndexPath as IndexPath], with: .bottom)
 saveAlerts()
 tableView.reloadData()
 
 }
 
 
 // MARK: NSCoding
 
 func saveAlerts(){
 let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(alerts, toFile: Alert.ArchiveURL.path)
 if(isSuccessfulSave){
 print ("Saved alerts successfully")
 }
 else
 {
 print("Failed to save alerts");
 }
 }
 
 func loadAlerts()->[Alert]?{
 return NSKeyedUnarchiver.unarchiveObject(withFile: Alert.ArchiveURL.path) as? [Alert]
 }
 
 
 
 }
 
 
*/*/
