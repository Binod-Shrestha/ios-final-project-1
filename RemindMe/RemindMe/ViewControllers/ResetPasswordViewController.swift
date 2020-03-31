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
    
    @IBOutlet weak var newPasswordLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    var foundUser : User?
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBAction func btnSecurityClicked(sender: UIButton) {
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        
        var email = tfEmail.text
        
        if email == nil || email == "" {
            let alertController = UIAlertController(title: "Error", message: "Please do not leave email field blank", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController,animated: true)
        } else {
            foundUser = mainDelegate.getUserByEmail(email: email!)
            
            if foundUser == nil {
                
                let alertController = UIAlertController(title: "Error", message: "Email cannot be found", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                present(alertController,animated: true)
            
                
            }
              
            else {
                var securityQuestions = mainDelegate.securityQuestions
                lbQuestion.text = securityQuestions[foundUser!.securityQuestion!]
                
                self.answerLabel.isHidden = false
                self.questionLabel.isHidden = false
                self.lbQuestion.isHidden = false
                self.tfAnswer.isHidden = false
                self.tfNewPassword.isHidden = false
                self.btnChangePassword.isHidden = false
                self.newPasswordLabel.isHidden = false
            }
        }
    }
    
    @IBAction func btnChangePasswordClicked(sender : UIButton) {
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let answer = tfAnswer.text
        
        if answer == nil || answer == "" {
            let alertController = UIAlertController(title: "Error", message: "Do not leave security answer blank", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController,animated: true)
        } else if answer != foundUser!.securityAnswer {
            let alertController = UIAlertController(title: "Error", message: "Please try again the answere entered doesnt match", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController,animated: true)
        } else {
            
            let password = tfNewPassword.text
            
            if password == nil || password == "" {
                let alertController = UIAlertController(title: "Error", message: "Do not leave password field balnk", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                present(alertController,animated: true)
            } else {
                let returnCode = mainDelegate.resetPassword(user: foundUser!, newPassword: password!)
                
                var returnMessage = "Successfully changed password"
                if returnCode == false {
                    returnMessage = "Could not change password. Please try again"
                }
                
                        let alertController = UIAlertController(title: "Success", message: returnMessage, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                present(alertController,animated: true)

            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

      
        self.answerLabel.isHidden = true
        self.questionLabel.isHidden = true
        self.lbQuestion.isHidden = true
        self.tfAnswer.isHidden = true
        self.tfNewPassword.isHidden = true
        self.btnChangePassword.isHidden = true
        self.newPasswordLabel.isHidden = true

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
