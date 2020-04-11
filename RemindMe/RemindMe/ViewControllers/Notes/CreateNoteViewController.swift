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
    
    @IBAction func btnAddImageClicked(sender:UIButton) {
        attachImageToText()
    }
    
    @IBAction func btnBackClicked(sender : UIBarButtonItem) {
        performSegue(withIdentifier: "CreateNoteToCreateTaskSegue", sender: nil)
    }

    @IBAction func btnDoneClicked(sender : UIBarButtonItem) {
        // End editing
        if btnDone.title == "Done" {
            var content = textView.text
            
            if (content == "" || content == nil) {
                btnDone.isEnabled = false
                btnDone.tintColor = UIColor.clear
            } else {
                btnDone.isEnabled = true
                btnDone.tintColor = nil
                btnDone.title = "Add"
            }
            
            textView.resignFirstResponder()
            textView.textColor = UIColor.lightGray
        } else {
            
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
    func textViewDidBeginEditing(_ textView: UITextView) {
        btnDone.isEnabled = true
        btnDone.tintColor = nil
        btnDone.title = "Done"
        
        textView.textColor = UIColor.black
    }
    
    // Dismiss the keyboard when the user touches outside the textview
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var content = textView.text
        
        if (content == "" || content == nil) {
            btnDone.isEnabled = false
            btnDone.tintColor = UIColor.clear
        } else {
            btnDone.isEnabled = true
            btnDone.tintColor = nil
            btnDone.title = "Add"
        }

        textView.resignFirstResponder()
        textView.textColor = UIColor.lightGray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide btnDone
        btnDone.isEnabled = false
        btnDone.tintColor = UIColor.clear
        
        // Show keyboard for textview
        textView.becomeFirstResponder()
    }
}
