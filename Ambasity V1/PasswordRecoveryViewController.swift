//
//  PasswordRecoveryViewController.swift
//  Ambasity V1
//
//  Created by Zak on 2/9/18.
//  Copyright © 2018 ClosestPath. All rights reserved.
//

import UIKit
import Parse

class PasswordRecoveryViewController: UIViewController {
    
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var emailField: UITextField!
    
    @IBOutlet var passwordRecoveryLabel: UILabel!
    @IBOutlet var forgotPasswordButton: SubmitButton!
    
    @IBOutlet var scrollView: UIScrollView!
    var activeField: UITextField!
    var resetComplete: Bool = false
    
    @IBAction func resetPassword(_ sender: Any) {
        if resetComplete {
            performSegue(withIdentifier: "toSignIn", sender: nil)
            usernameField.isHidden = false
            emailField.isHidden = false
            forgotPasswordButton.setTitle("Reset Password", for: UIControlState.normal)
            resetComplete = false
        } else {
            let successMessage: String = "Check your email for further instructions on resetting your password."
            
            if usernameField.text!.isEmpty == false && emailField.text!.isEmpty == false {
                PFUser.requestPasswordResetForEmail(inBackground: emailField.text!, block: { (success, error) in
                    if error != nil {
                        self.displayAlert(title: "Login Error", message: (error?.localizedDescription)!)
                    } else {
                        self.displayAlert(title: "Success!", message: successMessage)
                        self.usernameField.isHidden = true
                        self.emailField.isHidden = true
                        self.forgotPasswordButton.setTitle("Return To Home", for: UIControlState.normal)
                        self.resetComplete = true
                    }
                })
            } else {
                if (usernameField.text!.isEmpty) {
                    displayAlert(title: "Form Incomplete", message: "Please input your username.")
                }
                else {
                    displayAlert(title: "Form Incomplete", message: "Please input your email.")
                }
            }
        }
    }
    
    func displayAlert (title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func backPressed(_ sender: Any) {
        performSegue(withIdentifier: "toSignIn", sender: nil)
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
        
        usernameField.inputAccessoryView = toolBar
        emailField.inputAccessoryView = toolBar
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
