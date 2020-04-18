//
//  SignupPageViewController.swift
//  RemindMe
//
//  Created by Sherwin on 2020-03-19.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit



class SignupPageViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate ,UIPickerViewDataSource{
    
    @IBOutlet var tfemail : UITextField!
    @IBOutlet var tfpassword : UITextField!
    @IBOutlet var tfname : UITextField!
    @IBOutlet var tfconfirmPassword : UITextField!
    @IBOutlet weak var picker: UIPickerView!
    

    @IBOutlet weak var lblPickerTest: UILabel!
    @IBOutlet weak var tfsecurityAnswer: UITextField!
    
    var securityQuestions: [String] = [String]()
    var row : Int = 0
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return securityQuestions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return securityQuestions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.row  = row
    
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //Function is used to by the app to register the user into our app
    @IBAction func signUp(sender : Any)
    {
        let user : User = User(row: 0, email: tfemail.text!, password: tfpassword.text!, name: tfname.text!, securityQuestion: row, securityAnswer: tfsecurityAnswer.text!)
        
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if (tfpassword.text != tfconfirmPassword.text )
        {
            let alertController = UIAlertController(title: "Error", message: "Password and confirm password don't match ", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController,animated: true)
            
        }
        else if ( tfemail.text!.isEmpty || tfpassword.text!.isEmpty || tfname.text!.isEmpty || tfconfirmPassword.text!.isEmpty || tfsecurityAnswer.text!.isEmpty)
        {
            
            let alertController = UIAlertController(title: "Error", message: "Please do not leave any fields blank", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController,animated: true)
        }
        else{
            let returnCode = mainDelegate.signUp(user: user)
            
            var returnMsg : String = "You Have successfully registered"
            
            
            if returnCode == false
            {
                returnMsg = "User has not been added"
                
                
                let alertController = UIAlertController(title: "Error", message: returnMsg, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                present(alertController,animated: true)
            }
            
            let alertController = UIAlertController(title: "Success", message: returnMsg, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .default)  { (_)-> Void in   self.performSegue(withIdentifier: "SignUptoLoginSegue", sender: self) }
            alertController.addAction(cancelAction)
            present(alertController,animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.picker.delegate = self
        self.picker.dataSource = self
        
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        securityQuestions = mainDelegate.securityQuestions
        
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
