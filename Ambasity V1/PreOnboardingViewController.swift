//
//  PreOnboardingViewController.swift
//  Ambasity V1
//
//  Created by Zak on 3/25/18.
//  Copyright © 2018 ClosestPath. All rights reserved.
//

import UIKit

class PreOnboardingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func toOnboarding_TouchUpInside(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        let OnboardingViewController = storyboard.instantiateInitialViewController()!
        self.present(OnboardingViewController, animated: true)
    }
    
    @IBAction func skipOnboarding_TouchUpInside(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let MainViewController = storyboard.instantiateViewController(withIdentifier: "mainController")
        self.present(MainViewController, animated: true)
    }
    
}
