//
//  LoginPageViewController.swift
//  RemindMe
//
//  Created by Sherwin on 2020-03-19.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginPageViewController: UIViewController ,UITextFieldDelegate {
    @IBOutlet var tfemail : UITextField!
    @IBOutlet var tfpassword : UITextField!
    
    // Quynh: Declaration for Google Sign-in and NeedHelp buttons
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet var btnNeedHelp : UIButton!
    
    
    @IBAction func unwindToLoginVC(sender:UIStoryboardSegue){
        
    }
    
    @IBAction func btnNeedHelpClicked(sender: Any) {
        
    }
    
    // Quynh: Refresh the interface after user completes google sign in
    func refreshInterface() {
        //check if the user is already signed in
        print("Callback")
        if let _ = GIDSignIn.sharedInstance()?.currentUser?.authentication {
            self.performSegue(withIdentifier: "LogIntoHomeSegue", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Quynh: Google Sign-In implementation
        // Set up Callback
        refreshInterface()
        (UIApplication.shared.delegate as! AppDelegate).signIncallback = refreshInterface
        // Initialize Google sign-in
        GIDSignIn.sharedInstance()!.presentingViewController = self
        // Automatically sign in the user.
        if(GIDSignIn.sharedInstance()!.hasPreviousSignIn()) {
            GIDSignIn.sharedInstance()?.restorePreviousSignIn()
            self.performSegue(withIdentifier: "LogIntoHomeSegue", sender: self)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField)-> Bool {
        
        return textField.resignFirstResponder()
    }

    @IBAction func login(sender : Any)
    {
        let email = tfemail.text
        let password = tfpassword.text
        
        let user = User(email: email!, password: password!)
        
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let returnCode = mainDelegate.loginVerification(user: user)
        
        if returnCode == true
        {
            let returnMsg : String = "Login Successful"
            let alertController = UIAlertController(title: "Success", message: returnMsg, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .default)  { (_)-> Void in   self.performSegue(withIdentifier: "LogIntoHomeSegue", sender: self) }
            alertController.addAction(cancelAction)
            present(alertController,animated: true)
        }
            
        else if  returnCode == false
        {
            let alertController = UIAlertController(title: "Error", message: "Login failed please try again", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController,animated: true)
        }
    }

}
