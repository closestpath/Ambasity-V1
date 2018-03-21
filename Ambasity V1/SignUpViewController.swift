//
//  SignUpViewController.swift
//  Ambasity V1
//
//  Created by Zak on 11/18/17.
//  Copyright © 2017 ClosestPath. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var newUsername: UITextField!
    @IBOutlet var newEmail: UITextField!
    @IBOutlet var newPassword: UITextField!
    @IBOutlet var confirmPassword: UITextField!
    
    @IBOutlet var scrollView: UIScrollView!
    var activeField: UITextField!
    
    func displayAlert (title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signUp(_ sender: Any) {
        
        if newUsername.text!.isEmpty == false && newEmail.text!.isEmpty == false && newPassword.text!.isEmpty == false && confirmPassword.text!.isEmpty == false {
            
            if newPassword.text == confirmPassword.text {
                let user = PFUser()
                user.username = newUsername.text
                user.password = newPassword.text
                user.email = newEmail.text
                
                user.signUpInBackground(block: { (success, error) in
                    if success {
                        self.performSegue(withIdentifier: "toApp", sender: nil)
                    }
                    else {
                        self.displayAlert(title: "Error", message: (error?.localizedDescription)!)
                    }
                })
            }
            else {
                displayAlert(title: "Incorrect Password", message: "Passwords do not match.")
            }
        }
        else {
            if newUsername.text!.isEmpty {
                displayAlert(title: "Form Incomplete", message: "Please input a username.")
            }
            else if newEmail.text!.isEmpty {
                displayAlert(title: "Form Incomplete", message: "Please input an email.")
            }
            else if newPassword.text!.isEmpty {
                displayAlert(title: "Form Incomplete", message: "Please input a password.")
            }
            else {
                displayAlert(title: "Form Incomplete", message: "Please confirm password.")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Defining the tool bar to contain a button to exit the keyboard.
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        // Defining the button to exit the keyboard.
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        // Defining the spacer to push the exit button to the right.
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        // Adding the exit button and flexible space to the tool bar.
        toolBar.setItems([flexibleSpace, doneButton], animated: true)
        
        newUsername.inputAccessoryView = toolBar
        newEmail.inputAccessoryView = toolBar
        newPassword.inputAccessoryView = toolBar
        confirmPassword.inputAccessoryView = toolBar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Sets notifications for when the keyboard is in use.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Resets notification center if the view is exited.
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardDidShow(_ notification: Notification) {
        
        // Ensures there is data in the notification.
        if let info = notification.userInfo {
            // Ensures the keyboard size is contained in that data.
            if let kbSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size {
                // Scrolls up to make any text views hidden by the keyboard visible.
                let contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0)
                self.scrollView.contentInset = contentInsets
                self.scrollView.scrollIndicatorInsets = contentInsets
                
            } else {
                // Returns an error if the keyboard size is not contained in the notification data.
                print("Error: No keyboard size given in the notification information.")
            }
            
        } else {
            // Returns an error if there is no data in the notification.
            print("Error: No information given in the notification.")
        }
        
    }
    
    @objc func keyboardDidHide(_ notification: Notification) {
        
        // Resets the scroll view position when the keyboard has been dismissed.
        let contentInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
    }
    
    @objc
    func doneClicked() {
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
