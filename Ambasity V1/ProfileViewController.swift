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
    
    var brandsRepresenting = [String]()
    
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        // Logs the user out and segues them to the welcome screen.
        PFUser.logOut()
        performSegue(withIdentifier: "logoutSegue", sender: self)
    }
    
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
                            self.profileImageView.image = image
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
        
        updateScrollView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateProfilePicture(_ sender: Any) {
        // Creates the controller to select an image from the user's photo library.
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        // Displays the controller on the screen.
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Checking to make sure an image was selected.
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            // Making that image our profile image.
            profileImageView.image = image
            
            // Converting image into a data file.
            if let imageData = UIImagePNGRepresentation(image) {
                
                // Uploading the image file to the User's file in our database.
                PFUser.current()?["ProfileImage"] = PFFile(name: "profile.png", data: imageData)
                
                // Saving the changes.
                PFUser.current()?.saveInBackground(block: { (success, error) in
                    // Displays any encountered errors.
                    if error != nil {
                        self.displayAlert(title: "Error", message: error!.localizedDescription)
                    }
                })
            }
        }
        
        dismiss(animated: true, completion: nil)
    }

    // Creates an alert with title and message parameters.
    func displayAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func updateScrollView () {
        // Retrieving the information for the brands the user is representing.
        // Defining our query.
        let query = PFQuery(className: "Representing")
        query.whereKey("Ambassador", equalTo: PFUser.current()!)
        
        //Executing the query.
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                // Clears the old data.
                self.brandsRepresenting.removeAll()
                
                // Making sure objects are found.
                if let objects = objects {
                    
                    for object in objects {
                        // Making sure each object has an objectId.
                        if let objectId = object.objectId {
                            // Adding each objectId to our array.
                            self.brandsRepresenting.append(objectId)
                        }
                    }
                    
                    // Queries the specific brand information once the previous query has finished.
                    if self.brandsRepresenting.count == objects.count {
                        
                        self.retrieveBrandData()
                        print("hello")
                    }
                }
            } else {
                // Displays any encountered errors.
                self.displayAlert(title: "Error", message: error!.localizedDescription)
            }
        }
    }
    
    func retrieveBrandData () {
        //
        let query = PFQuery(className: "Brand")
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
