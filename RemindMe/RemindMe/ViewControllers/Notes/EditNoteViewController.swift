//
//  EditNoteViewController.swift
//  RemindMe
//
//  Created by Xcode User on 2020-03-24.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit

class EditNoteViewController: UIViewController, UITextViewDelegate {
    @IBOutlet var textView : UITextView!
    @IBOutlet var btnDone : UIBarButtonItem!
    @IBOutlet var btnAddImage : UIButton!
    
    @IBAction func btnAddImageClicked(sender:UIButton) {
        attachImageToText()
    }
    
    @IBAction func barItemClicked(sender : UIBarButtonItem) {
        if btnDone.title == "Edit" {
            textView.isEditable = true
            textView.becomeFirstResponder()
        } else {
            textView.resignFirstResponder()
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
    }
    
    func setEmptyTextViewStyle() {
        textView.isEditable = false
        textView.text = "Note"
        textView.textColor = UIColor.lightGray
    }
    
    // When the user begins to enter the note
    // Set the color to black
    // Change the title of BarItem from 'Edit' to 'Done'
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Note" {
            textView.text = ""
        }
        textView.textColor = UIColor.black
        btnDone.title = "Done"
    }
    
    // After the user finishes editing the note
    // Set text color to light gray
    // Change BarItem from 'Done' to 'Edit'
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            setEmptyTextViewStyle()
        }
        textView.textColor = UIColor.lightGray
        btnDone.title = "Edit"
    }
    
    // Dismiss the keyboard when the user touches outside the textview and the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Set up pre-enter textview as note
        setEmptyTextViewStyle()
        
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        
        var note = mainDelegate.getNoteById(id: 1)
        
        textView.text = note.content
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
