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
    
    func displayAlert (title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (action) in
            
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
