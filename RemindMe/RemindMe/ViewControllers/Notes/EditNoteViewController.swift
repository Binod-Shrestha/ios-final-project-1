//
//  EditNoteViewController.swift
//  RemindMe
//
//  Created by Quynh Dinh on 2020-03-24.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit

class EditNoteViewController: UIViewController, UITextViewDelegate {
    @IBOutlet var textView : UITextView!
    @IBOutlet var btnDone : UIBarButtonItem!
    @IBOutlet var btnUpdate : UIButton!
    @IBOutlet var btnDelete : UIButton!
    
    // btnDelete event handler
    @IBAction func btnDeleteClicked() {
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        var currentTask = mainDelegate.currentTask
        
        let alert = UIAlertController(title: "Confirmation", message: "Do you want to delete this note from the task?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) {
            (action) in
            
            currentTask!.note!.content = nil
            self.performSegue(withIdentifier: "UnwindFromEditNoteSegue", sender: nil)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        
        self.present(alert, animated: true)
    }
    
    // btnUpdate event handler
    @IBAction func btnUpdateClicked(sender : UIButton) {
        // Save the note to the current task
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        var note = mainDelegate.currentTask!.note
        
        var content = textView.text
        note!.content = content
        
        mainDelegate.currentTask!.note = note
        
        self.performSegue(withIdentifier: "UnwindFromEditNoteSegue", sender: nil)
    }
    
    // Dismiss the keyboard when the user clicks btnDone
    @IBAction func btnDoneClicked(sender : UIBarButtonItem) {
        var content = textView.text
        
        if (content == "" || content == nil) {
            btnUpdate.isEnabled = false
        } else {
            btnUpdate.isEnabled = true
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
        
        btnUpdate.isEnabled = false
        
        textView.textColor = UIColor.black
    }
    
    // Dismiss the keyboard when the user touches outside the textview
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var content = textView.text
        
        if (content == "" || content == nil) {
            btnUpdate.isEnabled = false
        } else {
            btnUpdate.isEnabled = true
        }
        
        btnDone.isEnabled = false
        btnDone.tintColor = UIColor.clear
        
        textView.resignFirstResponder()
        textView.textColor = UIColor.lightGray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Hide btnDone
        btnDone.isEnabled = false
        btnDone.tintColor = UIColor.clear
        
        // Disable the textview and set text color to grey
        textView.textColor = UIColor.lightGray
        
        // Get note of the current task
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        var currentNote = mainDelegate.currentTask!.note
        textView.text = currentNote?.content
    }
}
