//
//  ViewController.swift
//  RemindMe
//
//  Created by Xcode User on 2020-03-14.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var segmentControl : UISegmentedControl!
    @IBOutlet var btnCreate : UIBarButtonItem!
    @IBOutlet var tableView : UITableView!
    
    @IBAction func btnCreateTriggered(sender: UIBarButtonItem) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            performSegue(withIdentifier: "HomeToCreateDueDate", sender: nil)
            break
        case 1:
            performSegue(withIdentifier: "HomeToCreateNewTaskSegue", sender: nil)
            break
        case 2:
            break
        default:
            break
        }
    }
    
    @IBAction func segmentSelectValueChanged(sender:UISegmentedControl) {
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
            break
        default:
            break
        }
        
        return count
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
            break
        default:
            break
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            break
        case 1:
            //TODO: Change UserId
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
            break
        default:
            break
        }

        return cell
    }

    @IBAction func unwindToHomeVC(sender:UIStoryboardSegue){
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

