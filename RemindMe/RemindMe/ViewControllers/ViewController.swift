//
//  ViewController.swift
//  RemindMe
//
//  Created by Xcode User on 2020-03-14.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet var segmentControl : UISegmentedControl!
    @IBOutlet var btnCreate : UIBarButtonItem!
    @IBOutlet var btnLogOut : UIBarButtonItem!
    @IBOutlet var tableView : UITableView!
    
    var indexPath : IndexPath?
    
    var contacts : [Contact] = []
    
    @IBAction func btnLogOutTriggered(sender: UIBarButtonItem) {
        // Cancel object selection
        if btnLogOut.title == "Cancel" {
            var cell = self.tableView.cellForRow(at: indexPath!)
            cell?.isSelected = false
            
            btnLogOut.title = "Log Out"
            btnCreate.title = "+"
            
            indexPath = nil
        } else {
            let mainDelegate = UIApplication.shared.delegate as! AppDelegate
            mainDelegate.logOut()
            
            
            let alertController = UIAlertController(title: "Warning", message: "Do you want to log out ?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "Confirm", style: .default)  { (_)-> Void in   self.performSegue(withIdentifier: "logOutSegue", sender: self) }
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            
            present(alertController,animated: true)
        }
    }
    
    @IBAction func btnCreateTriggered(sender: UIBarButtonItem) {
        // Create new object
        if btnCreate.title == "+" {
            switch segmentControl.selectedSegmentIndex {
            case 0:
                performSegue(withIdentifier: "HomeToCreateDueDate", sender: nil)
                break
            case 1:
                // Display Create New Task ViewController
                let mainDelegate = UIApplication.shared.delegate as! AppDelegate
                mainDelegate.currentTask = nil
                performSegue(withIdentifier: "HomeToCreateNewTaskSegue", sender: nil)
                break
            case 2: // When Contacts selected in SegmentedController
                let mainDelegate = UIApplication.shared.delegate as! AppDelegate
                mainDelegate.currentContact = Contact() //Current contact se to empty contact object
                mainDelegate.updateContact = false // No existing contact to update
                performSegue(withIdentifier: "HometoEditContactSegue", sender: nil)
                break
            default:
                break
            }
        } else {
            // Delete object
            let mainDelegate = UIApplication.shared.delegate as! AppDelegate
            
            switch segmentControl.selectedSegmentIndex {
            case 0:
                break
            case 1:
                // Delete selected task
                var row = indexPath!.row
                
                let alert = UIAlertController(title: "Confirmation", message: "Do you want to delete the task?", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let confirmAction = UIAlertAction(title: "Confirm", style: .default) {
                    (action) in
                    
                    //TODO: Change user id
                    var tasks = mainDelegate.getTasksByUser(user_id: 1)
                    var task = tasks[row]
                    
                    let returnCode = mainDelegate.deleteTask(id: task.id!)
                    
                    var title : String = ""
                    var message : String = ""
                    var action = UIAlertAction()
                    
                    if returnCode == true {
                        // Successfully delete task
                        title = "Successfully"
                        message = "Deleted \(task.title!)"
                        action = UIAlertAction(title: "OK", style: .default) {
                            (action) in
                            self.tableView.reloadData()
                            self.btnCreate.title = "+"
                            self.btnLogOut.title = "Log Out"
                        }
                    } else {
                        // Delete task failed
                        title = "Error"
                        message = "Could not delete \(task.title!)"
                        action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    }
                    
                    var deleteAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    deleteAlert.addAction(action)
                    
                    self.present(deleteAlert, animated: true)

                }
                
                alert.addAction(cancelAction)
                alert.addAction(confirmAction)
                
                self.present(alert, animated: true)
                break
            case 2:
                break
            default:
                break
            }
        }
    }
    
    @IBAction func segmentSelectValueChanged(sender:UISegmentedControl) {
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        mainDelegate.getContactsByUserId()
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        var count : Int = 0
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            break
        case 1:
            //TODO: Change UserId
            let tasks = mainDelegate.getTasksByUser(user_id: 1)
            count = tasks.count
            break
        case 2:
            mainDelegate.getContactsByUserId() //Refresh contacts from db
            count = mainDelegate.contacts.count
            break
        default:
            break
        }
        return count
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        
            let delete = UITableViewRowAction(style: .destructive, title: "Delete", handler:
            {action, index in
                print("Delete swiped")
                
                let row = indexPath.row
                let id = mainDelegate.contacts[row].id
                mainDelegate.deleteContact(id: id!)
                self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                self.tableView.reloadData()
            })
            return [delete]
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height : CGFloat = 0
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            break
        case 1:
            height = 95
            break
        case 2:
            height = 85
            break
        default:
            break
        }
        
        return height
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            break
        case 1:
            //TODO: Change UserId
            print("Calling getTasksByUser()...")
            var tasks = mainDelegate.getTasksByUser(user_id: 1)
            
            cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TaskCell ?? TaskCell(style: .default, reuseIdentifier: "cell")
            
            // Populate cell
            let row = indexPath.row
            (cell as! TaskCell).lbTitle.text = tasks[row].title
            
            var priority : String = "Priority: "
            if tasks[row].priority == 0 {
                priority += "Low"
            } else if tasks[row].priority == 1 {
                priority += "Medium"
            } else {
                priority += "High"
            }
            (cell as! TaskCell).lbPriority.text = priority
            
            let dueDate = "Due date: \(tasks[row].taskDueDate!)"
            (cell as! TaskCell).lbTaskDueDate.text = dueDate

            break
        case 2:
            //Select background image:
            let backgroundImage = UIImage(named: "lite.jpg")
            
            //Remove extra empty cells from view
            let imageView = UIImageView(image: backgroundImage)
            self.tableView.backgroundView = imageView
            tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            imageView.contentMode = .scaleAspectFit
            
            // Populate Contacts list by user for view
             mainDelegate.getContactsByUserId()
            
            cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ContactCell ?? ContactCell(style: .default, reuseIdentifier: "cell")
            
            // Populate cell
            let row = indexPath.row
            
            
            (cell as! ContactCell).nameLabel.text = mainDelegate.contacts[row].name
            (cell as! ContactCell).organizationLabel.text = mainDelegate.contacts[row].organization
            (cell as! ContactCell).phoneLabel.text = mainDelegate.contacts[row].phone
            (cell as! ContactCell).emailLabel.text = mainDelegate.contacts[row].email

            cell.accessoryType = .disclosureIndicator
            break
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            break
        case 1:
            let mainDelegate = UIApplication.shared.delegate as! AppDelegate
            let tasks = mainDelegate.getTasksByUser(user_id: 1)
            
            let row = indexPath.row
            mainDelegate.currentTask = tasks[row]
            
            performSegue(withIdentifier: "HomeToEditTaskSegue", sender: nil)
            break
        case 2:
            let mainDelegate = UIApplication.shared.delegate as! AppDelegate
            mainDelegate.getContactsByUserId()
            
            let row = indexPath.row
            mainDelegate.currentContact = mainDelegate.contacts[row]
            
            performSegue(withIdentifier: "HomeToContactDetailSegue", sender: nil)
            break
        default:
            break
        }
    }

    @IBAction func unwindToHomeVC(sender:UIStoryboardSegue){
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Long Press Gesture
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 1.0
        longPressGesture.delegate = self
        self.tableView.addGestureRecognizer(longPressGesture)
        self.tableView.reloadData()
    }
    
    @objc func handleLongPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
            let touchPoint = longPressGestureRecognizer.location(in: self.tableView)

            if let selectedIndexPath = tableView.indexPathForRow(at: touchPoint) {
                btnLogOut.title = "Cancel"
                btnCreate.title = "Delete"
                
                var cell = tableView.cellForRow(at: selectedIndexPath)
                cell?.isSelected = true
                //cell?.backgroundColor = UIColor.lightGray
                indexPath = selectedIndexPath
                
                print("Row \(selectedIndexPath.row)")
            }
        }
    }
}

