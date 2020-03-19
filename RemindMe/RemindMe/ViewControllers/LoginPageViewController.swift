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
    @IBOutlet var tfpassowrd : UITextField!
    @IBOutlet var lbEmail : UILabel!
    @IBOutlet var lbPassword : UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(_ textField: UITextField)-> Bool {
        
        return textField.resignFirstResponder()
        
    }
    @IBAction func login(sender : UIButton)
    {
        
        self.doTheUpdate();
        
    }
    func doTheUpdate()
    {
        
        let email = tfemail.text
        let password = tfpassowrd.text
        let mydata = User()
        mydata.inWithData(theEmail: email!, thePassword: password!)
        
        lbEmail.text = mydata.email
        lbPassword.text = mydata.password
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
