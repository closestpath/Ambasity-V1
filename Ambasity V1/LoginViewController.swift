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
    
    @IBOutlet weak var logoBackdrop: UIView!
    
    
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    func displayAlert (title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (action) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
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
        activityIndicator.center.x = self.view.center.x
        activityIndicator.center.y = self.view.center.y + 250
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil {
            UIApplication.shared.endIgnoringInteractionEvents()
            performSegue(withIdentifier: "toApp", sender: self)
        }
        else {
            UIApplication.shared.endIgnoringInteractionEvents()
            activityIndicator.stopAnimating()
        }
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
