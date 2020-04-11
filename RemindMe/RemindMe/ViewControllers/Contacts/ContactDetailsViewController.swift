//
//  ContactDetailsViewController.swift
//  RemindMe
//
//  Created by Xcode User on 2020-03-30.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit

class ContactDetailsViewController: UIViewController {

    @IBOutlet var lblName : UILabel?
    @IBOutlet var lblOrganization : UILabel?
    @IBOutlet var lblTitle : UILabel?
    @IBOutlet var lblPhone : UILabel?
    @IBOutlet var lblEmail : UILabel?
    @IBOutlet var lblDiscord : UILabel?
    @IBOutlet var lblSlack : UILabel?
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
        
        lblName?.text = contact?.name
        lblOrganization?.text = contact?.organization
        lblTitle?.text = contact?.title
        lblPhone?.text = contact?.phone
        lblEmail?.text = contact?.email
        lblDiscord?.text = contact?.discord
        lblSlack?.text = contact?.slack
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
