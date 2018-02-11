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
    
    @IBAction func resetPassword(_ sender: Any) {
        if usernameField.text!.isEmpty == false && emailField.text!.isEmpty == false {
            PFUser.requestPasswordResetForEmail(inBackground: emailField.text!, block: { (success, error) in
                if error != nil {
                    self.displayAlert(title: "Login Error", message: (error?.localizedDescription)!)
                } else {
                    self.displayAlert(title: "Success!", message: "Check your email for further instructions on resetting your password.")
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
    
    @IBAction func backPressed(_ sender: Any) {
        performSegue(withIdentifier: "toSignIn", sender: nil)
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
    
    func displayAlert (title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }

}
