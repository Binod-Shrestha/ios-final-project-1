//
//  EditContactViewController.swift
//  RemindMe
//
//  Created by Brian Holmes on 2020-03-30.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit

class EditContactViewController: UIViewController {
    //Properties
    @IBOutlet var tfName : UITextField?
    @IBOutlet var tfOrganization : UITextField?
    @IBOutlet var tfTitle : UITextField?
    @IBOutlet var tfPhone : UITextField?
    @IBOutlet var tfEmail : UITextField?
    @IBOutlet var tfDiscord : UITextField?
    @IBOutlet var tfSlack : UITextField?
    @IBOutlet var tvNotes : UITextView?
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
   
    
    @IBAction func clickSave(){
        // Capture the details of contact on Edit screen
        //MARK, remove tempUserId
        let newContact = Contact.init(theOwerUser: mainDelegate.currentUser!.id!, theName: tfName!.text!, theOrganization: tfOrganization!.text!, theTitle: tfTitle!.text!, thePhone: tfPhone!.text!, theEmail: tfEmail!.text!, theDiscord: tfDiscord!.text!, theSlack: tfSlack!.text!, theNotes: tvNotes!.text)
        
        // Main delegate is set to true when navigating from an existing contact
        if mainDelegate.updateContact == true
        {
            let updateResult = mainDelegate.UpdateContact(contact: newContact)
            if updateResult == true
            {
                print("User Saved.")
            }
            else
            {
                print("Unable to Save user.")
            }
            performSegue(withIdentifier: "EditContactToContactDetailVCSegue", sender: nil)
        }
        else // Main delegate is set to false when navigating from create new contact
        {
            print("....saving new contact...:\(String(describing: newContact.name))")
            mainDelegate.currentContact = newContact // newContact is assigned to the mainDelegate's currentContact so it is displayed on segue to ContactDetailViewCoontroller
            let newSaveResult = mainDelegate.insertContactIntoDatabase(contact: newContact)
            if newSaveResult == true
            {
                print("User updated.")
            }
            else
            {
                print("Unable to save user.")
            }
            performSegue(withIdentifier: "EditContactToContactDetailVCSegue", sender: nil)
        }
    }
//    @IBAction func ClickDelete(){
//        mainDelegate.deleteContact(id: mainDelegate.currentContact!.id!)
//        // MARK: Create this segue
//        //performSegue(withIdentifier: "EditContactToHomeVCSegue", sender: nil)
//        
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let contact = mainDelegate.currentContact ?? Contact() // When a currentContact is assigned, fields are populated with those values, if not, fields are populated from an empty 'contact' object
        
        tfName?.text = contact.name
        tfOrganization?.text = contact.organization
        tfTitle?.text = contact.title
        tfPhone?.text = contact.phone
        tfEmail?.text = contact.email
        tfDiscord?.text = contact.discord
        tfSlack?.text = contact.slack
        tvNotes?.text = contact.notes
    }
}
