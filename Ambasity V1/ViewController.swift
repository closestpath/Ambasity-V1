//
//  ViewController.swift
//  Ambasity V1
//
//  Created by Zak on 11/16/17.
//  Copyright © 2017 ClosestPath. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBAction func signInPressed(_ sender: Any) {
        performSegue(withIdentifier: "toSignIn", sender: nil)
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()!
        self.present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

