//
//  CreateNoteViewController.swift
//  RemindMe
//
//  Created by Xcode User on 2020-03-19.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit

class CreateNoteViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var textView : UITextView!
    @IBOutlet var btnDone : UIBarButtonItem!
    @IBOutlet var btnBack : UIBarButtonItem!
    @IBOutlet var btnAddImage : UIButton!
    
    @IBAction func unwindToCreateNote(sender : UIStoryboardSegue) {}
    
    @IBAction func btnAddImageClicked(sender:UIButton) {
        attachImageToText()
    }
    
    @IBAction func btnBackClicked(sender : UIBarButtonItem) {
        performSegue(withIdentifier: "CreateNoteToCreateTaskSegue", sender: nil)
    }
    
    //TODO: Fix CreateNote function
    @IBAction func btnDoneClicked(sender : UIBarButtonItem) {
        // End editing
        if btnDone.title == "Done" {
            textView.resignFirstResponder()
        } else {
            // Save note to task
            let mainDelegate = UIApplication.shared.delegate as! AppDelegate
            let currentUser : User = mainDelegate.currentUser!
            let task : Task = mainDelegate.currentTask!
            
            let content = textView.text
            
            var returnCode = false
            
            // Fix note content
            if(content != "") {
                let note = Note.init(content: content!, task_id: task.id, duedate_id: nil, user_id: currentUser.id!)
                
                let mainDelegate = UIApplication.shared.delegate as! AppDelegate
                mainDelegate.currentTask!.note = note
                performSegue(withIdentifier: "CreateNoteToCreateTaskSegue", sender: self)
//                returnCode = mainDelegate.insertNote(note: note)
            }
            
//            var returnMesage = "Successfully Inserted Note"
//
//            if returnCode == false {
//                returnMesage = "Insert Note Failed"
//            }
//
//            let alertController = UIAlertController(title: "Insert Note", message: returnMesage, preferredStyle: .alert)
//            let  cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//
//            alertController.addAction(cancelAction)
//            present(alertController, animated: true)
        }
    }
    
    // Attach image to the text
    func attachImageToText() {
        
        let image = UIImage(named: "gg-background.jpg")
        
        let imageRatio = image!.size.width/image!.size.height
        
        // Initiate an attachment with inserted image
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = CGRect(x: 0, y: 0, width: imageRatio * 150, height: 150)
        
        // Add the attachment to an attributed string
        let attributeString = NSAttributedString(attachment: attachment)
        
        // Add the attributed string to the current position of the text view
        textView.textStorage.insert(attributeString, at: textView.selectedRange.location)
        
        print("AttributedString: \(textView.attributedText.string)")
    }
    
    // When the user begins to enter the note
    // Set the color to black
    // Change the title of BarItem from 'Add' to 'Done'
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.textColor = UIColor.black
        btnDone.title = "Done"
    }
    
    // After the user finishes editing the note
    // Set text color to light gray
    // Change BarItem from 'Done' to 'Add'
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.textColor = UIColor.lightGray
        }
        textView.textColor = UIColor.lightGray
        btnDone.title = "Add"
    }
    
    // Dismiss the keyboard when the user touches outside the textview and the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        
        var currentNote = mainDelegate.currentTask!.note
        
        textView.text = currentNote?.content
    }
}
