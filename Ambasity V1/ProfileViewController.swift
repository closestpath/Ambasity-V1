//
//  ProfileViewController.swift
//  Ambasity V1
//
//  Created by Zak on 12/20/17.
//  Copyright © 2017 ClosestPath. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {
    
    private var user: User?
    
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    
    var brandIds = [String]()
    var brandNames = [String]()
    var brandLogos = [UIImage]()
    var logoType : String!
    
    var profileImage: UIImage?
    
// Main View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getUserData()
        setupLayout()
    }
    
// View Setup
    private func getUserData() {
        guard let currentUser = PFUser.current() else { return }
        
        let username = currentUser.username!
        let email = currentUser.email!
        let phoneNumber = currentUser["phoneNumber"] as? String
        let bio = currentUser["bio"] as? String
        let message = currentUser["personalizedMessage"] as? String
        let profileImageFile = currentUser["profileImage"] as? PFFile
        let venmoId = currentUser["venmoId"] as? String
        let paypalUsername = currentUser["paypalUsername"] as? String
        
        user = User(username: username, email: email, phoneNumber: phoneNumber, bio: bio, message: message, profileImageFile: profileImageFile, venmoId: venmoId, paypalUsername: paypalUsername)
    }
    
    private func setupLayout() {
        usernameLabel.text = user?.username
        emailLabel.text = user?.email
        profileImageView.layer.cornerRadius = (profileImageView.frame.size.width / 2)
        
        if let profileImageFile = user?.profileImageFile {
            
            profileImageFile.getDataInBackground(block: { (data, error) in
                
                if error != nil {
                    
                    let alert = UIAlertController(title: "Error", message: "Parse Server: \(error!.localizedDescription)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    
                    guard let imageData = data else { return }
                    guard let image = UIImage(data: imageData) else { return }
                    
                    self.profileImage = image
                    self.profileImageView.image = image
                    
                }
            })
        }
    }
   
// Button Targets
    @IBAction func supportButton_TouchUpInside(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Support", bundle: nil)
        let supportViewController = storyboard.instantiateInitialViewController()!
        self.present(supportViewController, animated: true)
    }
    
    
    @IBAction func settingsButton_TouchUpInside(_ sender: Any) {
        performSegue(withIdentifier: "toSettings", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSettings" {
            
            guard let destinationViewController = segue.destination as? UINavigationController else { return }
            guard let settingsTableViewController = destinationViewController.topViewController  as? SettingsTableViewController else { return }
            
            guard let unwrappedUser = user else { return }
            settingsTableViewController.user = unwrappedUser
            
            guard let unwrappedProfileImage = profileImage else { return }
            settingsTableViewController.profileImage = unwrappedProfileImage
            
        }
    }
}
