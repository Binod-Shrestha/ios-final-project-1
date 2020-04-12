//
//  CreateNoteViewController.swift
//  RemindMe
//
//  Created by Quynh Dinh on 2020-03-19.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit

class CreateNoteViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var textView : UITextView!
    @IBOutlet var btnDone : UIBarButtonItem!
    @IBOutlet var btnBack : UIBarButtonItem!
    @IBOutlet var btnAdd : UIButton!
    
    // btnAdd event handler
    @IBAction func btnAddClicked(sender : UIButton) {
        // Save note to task
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        let currentUser : User = mainDelegate.currentUser!
        let task : Task = mainDelegate.currentTask!
        
        var content = textView.text
        
        if (content == "" || content == nil) {
            var alert = UIAlertController(title: "Warning", message: "Please enter note content!", preferredStyle: .alert)
            var cancelAction  = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            present(alert, animated: true)
        } else {
            let note = Note.init(content: content!)
            
            let mainDelegate = UIApplication.shared.delegate as! AppDelegate
            mainDelegate.currentTask!.note = note
            performSegue(withIdentifier: "UnwindFromCreateNoteSeugue", sender: self)
        }
    }
    
    // btnDone event handler
    @IBAction func btnDoneClicked(sender : UIBarButtonItem) {
        // End editing
        var content = textView.text
        
        if (content == "" || content == nil) {
            btnAdd.isEnabled = false
        } else {
            btnAdd.isEnabled = true
        }
        
        btnDone.isEnabled = false
        btnDone.tintColor = UIColor.clear
        
        textView.resignFirstResponder()
        textView.textColor = UIColor.lightGray
    }
    
    // When the user begins to enter the note
    func textViewDidBeginEditing(_ textView: UITextView) {
        btnDone.isEnabled = true
        btnDone.tintColor = nil
        btnDone.title = "Done"
        
        btnAdd.isEnabled = false
        
        textView.textColor = UIColor.black
    }
    
    // Dismiss the keyboard when the user touches outside the textview
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var content = textView.text
        
        if (content == "" || content == nil) {
            btnAdd.isEnabled = false
        } else {
            btnAdd.isEnabled = true
        }
        
        btnDone.isEnabled = false
        btnDone.tintColor = UIColor.clear
        
        textView.resignFirstResponder()
        textView.textColor = UIColor.lightGray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Enable btnDone
        btnDone.isEnabled = true
        btnDone.tintColor = UIColor.black
        
        // Disable btnAdd
        btnAdd.isEnabled = false
        
        // Show keyboard for textview
        textView.becomeFirstResponder()
    }
}
