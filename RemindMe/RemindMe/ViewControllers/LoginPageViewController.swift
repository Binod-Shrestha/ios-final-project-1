//
//  LoginPageViewController.swift
//  RemindMe
//
//  Created by Sherwin on 2020-03-19.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit

class LoginPageViewController: UIViewController ,UITextFieldDelegate{
    @IBOutlet var tfemail : UITextField!
    @IBOutlet var tfpassword : UITextField!
    @IBOutlet var lbEmail : UILabel!
    @IBOutlet var lbPassword : UILabel!
    
    @IBAction func unwindToLoginVC(sender:UIStoryboardSegue){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
            var returnMsg : String = "Login Successful"
            let alertController = UIAlertController(title: "SQl Lite Add", message: returnMsg, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .default)  { (_)-> Void in   self.performSegue(withIdentifier: "LogIntoHomeSegue", sender: self) }
            alertController.addAction(cancelAction)
            present(alertController,animated: true)
        }
            
        else if  returnCode == false
        {
            
            
            let alertController = UIAlertController(title: "SQl Lite Add", message: "Login Faileed Please try again", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController,animated: true)
        }
        
        let email = tfemail.text
        let password = tfpassowrd.text

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
