//
//  ViewController.swift
//  Ambasity V1
//
//  Created by Zak on 11/16/17.
//  Copyright © 2017 ClosestPath. All rights reserved.
//

import UIKit
import Parse

extension UIColor {
    
    static var mainBlue = UIColor(red: 60/255, green: 190/255, blue: 1, alpha: 1)
    
}

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBAction func signInPressed(_ sender: Any) {
        performSegue(withIdentifier: "toSignIn", sender: nil)
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()!
        self.present(vc, animated: true, completion: nil)
        //performSegue(withIdentifier: "toSignUp", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

