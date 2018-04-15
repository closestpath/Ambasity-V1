//
//  ProfileViewController.swift
//  Ambasity V1
//
//  Created by Zak on 12/20/17.
//  Copyright © 2017 ClosestPath. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let currentUser = PFUser.current()
        // Checking to make sure a username exists.
        if let username = currentUser?.username {
            // Changing the label to display the current user's username.
            usernameLabel.text = "@" + username
        }
        
        // Checking to make sure an email exists.
        if let email = currentUser?.email {
            // Changing the label to display the current user's email address.
            emailLabel.text = email
        }
        
        // Checking to make sure a profile photo exists.
        if let profileImageFile = currentUser?["ProfileImage"] as? PFFile {
            
            // Downloading the file.
            profileImageFile.getDataInBackground(block: { (data, error) in
                if error == nil {
                    
                    if let imageData = data {
                        // Making sure the image data can be converted into a UIImage.
                        if let image = UIImage(data: imageData) {
                            // Displaying the downloaded profile image.
                            self.profileImage = image
                            self.profileImageView.image = self.profileImage
                        }
                    }
                    
                } else {
                    // Displays any encountered errors.
                    self.displayAlert(title: "Error", message: error!.localizedDescription)
                }
            })
            
        }
        
        // Rounds the edges to the profile image view.
        profileImageView.layer.cornerRadius = (profileImageView.frame.size.width / 2)
        
        //updateScrollView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Creates an alert with title and message parameters.
    func displayAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    /*func updateScrollView () {
        // Retrieving the information for the brands the user is representing.
        // Defining our query.
        let query = PFQuery(className: "Representing")
        query.whereKey("Ambassador", equalTo: PFUser.current()!)
        
        //Executing the query.
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                // Clears the old data.
                self.brandIds.removeAll()
                
                // Making sure objects are found.
                if let objects = objects {
                    
                    for object in objects {
                        
                        // Making sure each object is a brand object.
                        if let brand = object["Brand"] as? PFObject {
                            // Making sure each brand has an id.
                            if let brandId = brand.objectId {
                                
                                self.brandIds.append(brandId)
                                
                            }
                        }
                        
                    }
                    print(self.brandIds.count)
                    print(objects.count)
                    if self.brandIds.count == objects.count {
                        
                        self.retrieveBrandData(self.brandIds)
                    }
                }
            } else {
                // Displays any encountered errors.
                self.displayAlert(title: "Error", message: error!.localizedDescription)
            }
        }
    }
    
    func retrieveBrandData (_ brandIds: [String]) {
        
        // Defining our inner query to query the specific brand information.
        let query = PFQuery(className: "Brand")
        query.whereKey("objectId", containedIn: brandIds)
        
        // Executing our innery query.
        query.findObjectsInBackground(block: { (objects, error) in
            
            if error == nil {
                // Making sure objects are found.
                if let objects = objects {
                    
                    for object in objects {
                        // Making sure the brand has a name.
                        if let brandName = object["Name"] as? String {
                            // Adding that name to our brands list.
                            self.brandNames.append(brandName)
                        }
                        // Making sure the brand has a logo file.
                        if let logoImageFile = object[self.logoType] as? PFFile {
                            // Downloading the file.
                            logoImageFile.getDataInBackground(block: { (data, error) in
                                if error == nil {
                                    
                                    if let imageData = data {
                                        // Making sure the image data can be converted into a UIImage.
                                        if let image = UIImage(data: imageData) {
                                            // Displaying the downloaded profile image.
                                            self.brandLogos.append(image)
                                        }
                                    }
                                    
                                } else {
                                    // Displays any encountered errors.
                                    self.displayAlert(title: "Error", message: error!.localizedDescription)
                                }
                            })
                        }
                    }
                }
            } else {
                // Displays any encountered errors.
                self.displayAlert(title: "Error", message: error!.localizedDescription)
            }
        })
        
    }*/
    
    @IBAction func supportButton_TouchUpInside(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SupportViewController", bundle: nil)
        let supportViewController = storyboard.instantiateInitialViewController()!
        self.present(supportViewController, animated: true)
    }
    
    
    @IBAction func settingsButton_TouchUpInside(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let supportViewController = storyboard.instantiateInitialViewController()!
        self.present(supportViewController, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSettings" {
            let settingsViewController = segue.destination as! SettingsViewController
            if let image = profileImage {
                settingsViewController.profilePhoto?.image = image
            }
        }
    }

}
