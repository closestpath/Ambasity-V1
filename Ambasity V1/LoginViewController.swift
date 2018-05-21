//
//  LoginViewController.swift
//  Ambasity V1
//
//  Created by Zak on 11/18/17.
//  Copyright © 2017 ClosestPath. All rights reserved.
//

import UIKit
import CoreData
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    let overlay = UIView()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    @IBOutlet var scrollView: UIScrollView!
    
    var activeField: UITextField!
    
    @IBAction func signIn(_ sender: Any) {
        
        if usernameField.text!.isEmpty == false && passwordField.text!.isEmpty == false {
            
            PFUser.logInWithUsername(inBackground: usernameField.text!, password: passwordField.text!, block: { (user, error) in
                if user != nil {
                    self.performSegue(withIdentifier: "toApp", sender: nil)
                }
                else {
                    self.displayAlert(title: "Login Error", message: (error?.localizedDescription)!)
                }
            })
        }
        else {
            if (usernameField.text!.isEmpty) {
                displayAlert(title: "Form Incomplete", message: "Please input a username.")
            }
            else {
                displayAlert(title: "Form Incomplete", message: "Please input a password.")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.startActivityIndicator(overlay: overlay, activityIndicator: activityIndicator)
        
        // Defining the tool bar to contain a button to exit the keyboard.
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        // Defining the button to exit the keyboard.
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        // Defining the spacer to push the exit button to the right.
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        // Adding the exit button and flexible space to the tool bar.
        toolBar.setItems([flexibleSpace, doneButton], animated: true)
        
        // Adding to the tool bar to the two text fields' keyboards.
        usernameField.inputAccessoryView = toolBar
        passwordField.inputAccessoryView = toolBar
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // If the user is currently logged in, redirect them to the application home page.
        if PFUser.current() != nil {
            UIApplication.shared.endIgnoringInteractionEvents()
            performSegue(withIdentifier: "toApp", sender: self)
        }
        // If the user is not currently logged in.
        else {
            view.stopActivityIndicator(overlay: overlay, activityIndicator: activityIndicator)
        }
        
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
}
