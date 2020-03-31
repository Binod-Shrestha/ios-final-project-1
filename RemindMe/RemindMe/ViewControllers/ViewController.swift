//
//  ViewController.swift
//  RemindMe
//
//  Created by Xcode User on 2020-03-14.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var btnLogOut : UIBarButtonItem!
    
    @IBAction func btnLogOutClicked(sender : UIBarButtonItem) {
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        mainDelegate.logOut()
        
        
        let alertController = UIAlertController(title: "Warning", message: "Do you want to log out ?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "Confirm", style: .default)  { (_)-> Void in   self.performSegue(withIdentifier: "logOutSegue", sender: self) }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
    
        present(alertController,animated: true)
    }
    
    @IBAction func unwindToHomeVC(sender:UIStoryboardSegue){
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

