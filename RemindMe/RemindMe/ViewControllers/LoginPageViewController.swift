//
//  LoginPageViewController.swift
//  RemindMe
//
//  Created by Sherwin on 2020-03-19.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit
//import FacebookCore
//import FacebookLogin

class LoginPageViewController: UIViewController ,UITextFieldDelegate{
    
    @IBOutlet var tfemail : UITextField!
    @IBOutlet var tfpassword : UITextField!

    @IBAction func unwindToLoginVC(sender:UIStoryboardSegue){
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       /* var loginButton = FBLoginButton(permissions: [ .publicProfile ])
       //view.addSubview(loginButton)
    //    loginButton.center = view.center
      
        loginButton = FBLoginButton(
            permissions: [ .publicProfile, .email, .userFriends ]
        )
        if let accessToken = AccessToken.current{
            print("User Has been Logged In")
            print(accessToken)
            performSegue(withIdentifier: "LogIntoHomeSegue", sender: self)
        }
 */
    }
    
    /*func loginManagerDidComplete(_ result: LoginResult) {
         let alertController: UIAlertController
         switch result {
         case .cancelled:
            (
                 print ("Login Cancelled")
            )
         case .failed(let error):
            (
                print ("Login Failed")
            )
         case .success(let grantedPermissions, _, _):
             alertController = UIAlertController(
                 title: "Login Success",
                 message: "Login succeeded with granted permissions: \(grantedPermissions)", preferredStyle: .alert
                
             )
             self.performSegue(withIdentifier: "LogIntoHomeSegue", sender: self )
         }
    }
    
    @IBAction  func loginWithReadPermissions() {
          let loginManager = LoginManager()
          loginManager.logIn(
              permissions: [.publicProfile, .userFriends],
              viewController: self
          ) { result in
              self.loginManagerDidComplete(result)
          }
      }
 */
    
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
