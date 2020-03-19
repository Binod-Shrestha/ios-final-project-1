//
//  SignupPageViewController.swift
//  RemindMe
//
//  Created by Sherwin on 2020-03-19.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit

class SignupPageViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet var email : UITextField!
    @IBOutlet var passowrd : UITextField!
    @IBOutlet var name : UITextField!
    @IBOutlet var confirmPassword : UITextField!
    @IBOutlet var postalCode : UITextField!
    @IBOutlet var streetName : UITextField!
    @IBOutlet var phoneNumber : UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(_ textField: UITextField)-> Bool {
        
        return textField.resignFirstResponder()
        
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
