//
//  Onboarding2ViewController.swift
//  Ambasity V1
//
//  Created by Zak on 3/29/18.
//  Copyright © 2018 ClosestPath. All rights reserved.
//

import UIKit

class Onboarding2ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func doneButton_TouchUpInside(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let MainViewController = storyboard.instantiateViewController(withIdentifier: "mainController")
        self.present(MainViewController, animated: true)
    }
    

}
