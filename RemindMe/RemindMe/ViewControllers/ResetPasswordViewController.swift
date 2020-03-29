//
//  ResetPasswordViewController.swift
//  RemindMe
//
//  Created by Sherwin on 2020-03-29.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet var tfEmail : UITextField!
    @IBOutlet var tfAnswer: UITextField!
    @IBOutlet var tfNewPassword : UITextField!
    
    @IBOutlet var lbQuestion : UILabel!
    
    @IBOutlet var btnSecurity : UIButton!
    @IBOutlet var btnChangePassword : UIButton!
    
    var foundUser : User?
    
    @IBAction func btnSecurityClicked(sender: UIButton) {
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        
        var email = tfEmail.text
        
        if email == nil || email == "" {
            //TODO: Display alert
            // Display an alert to ask user to enter email
        } else {
            foundUser = mainDelegate.getUserByEmail(email: email!)
            
            if foundUser == nil {
                
                //TODO: Display alert
                // Display an alert that says "Could not find the email..."
                
            } else {
                var securityQuestions = mainDelegate.securityQuestions
                lbQuestion.text = securityQuestions[foundUser!.securityQuestion!]
                
                //TODO: Write Code
                // Write code to show security question label, answer textfield, ..
            }
        }
    }
    
    @IBAction func btnChangePasswordClicked(sender : UIButton) {
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let answer = tfAnswer.text
        
        if answer == nil || answer == "" {
            //TODO: Display alert
            // Display an alert that says "Please enter security answer"
        } else if answer != foundUser!.securityAnswer {
            //TODO: Display alert
            // Display an alert to tell user try again as the entered answer is wrong
        } else {
            
            let password = tfNewPassword.text
            
            if password == nil || password == "" {
                //TODO: Display alert
                // Display alert to ask user to enter the new password (dont leave it blank)
            } else {
                let returnCode = mainDelegate.resetPassword(user: foundUser!, newPassword: password!)
                
                var returnMessage = "Successfully changed password"
                if returnCode == false {
                    returnMessage = "Could not change password. Please try again"
                }
                
                //TODO: Display alert
                // Display alert to show returnMessage
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //TODO: Write Code
        // Write code to hide the security question label,  answer textfield, ...
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
