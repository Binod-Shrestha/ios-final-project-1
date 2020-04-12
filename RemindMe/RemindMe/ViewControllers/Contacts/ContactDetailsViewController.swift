//
//  ContactDetailsViewController.swift
//  RemindMe
//
//  Created by Brian Holmes on 2020-03-30.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit

class ContactDetailsViewController: UIViewController {

    @IBOutlet var tfName : UITextField?
    @IBOutlet var tfOrganization : UITextField?
    @IBOutlet var tfTitle : UITextField?
    @IBOutlet var tfPhone : UITextField?
    @IBOutlet var tfEmail : UITextField?
    @IBOutlet var tfDiscord : UITextField?
    @IBOutlet var tfSlack : UITextField?
    @IBOutlet var tvNotes : UITextView?

    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    @IBAction func clickedEditContact(sender : Any){
        mainDelegate.updateContact = true
        performSegue(withIdentifier: "ContactDetailToEditContactSegue", sender: nil)
    }
    @IBAction func unwindToContactDetailVC(sender:UIStoryboardSegue){
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let contact = mainDelegate.currentContact
        
        tfName?.text = contact?.name
        tfOrganization?.text = contact?.organization
        tfTitle?.text = contact?.title
        tfPhone?.text = contact?.phone
        tfEmail?.text = contact?.email
        tfDiscord?.text = contact?.discord
        tfSlack?.text = contact?.slack
        tvNotes?.text = contact?.notes
        
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
