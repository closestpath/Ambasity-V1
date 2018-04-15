//
//  SettingsViewController.swift
//  Ambasity V1
//
//  Created by Zak on 3/29/18.
//  Copyright © 2018 ClosestPath. All rights reserved.
//

import UIKit
import Parse

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var profilePhoto: UIImageView!
    
    let settingLabels = [
        ["Account Settings"],
        ["Username", "Email", "Phone", "Bio", "Message"],
        ["General"],
        ["Payment", "Change Password", "Support"]
    ]

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Rounds the edges to the profile image view.
        profilePhoto.layer.cornerRadius = (profilePhoto.frame.size.width / 2)
    }
    
    @IBAction func cancelButton_TouchUpInside(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton_TouchUpInside(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Changing the profile image.
    @IBAction func changeProfileImage(_ sender: Any) {
        // Creates the controller to select an image from the user's photo library.
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        // Displays the controller on the screen.
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Checking to make sure an image was selected.
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            // Making that image our profile image.
            profilePhoto.image = image
            
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
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // Creates an alert with title and message parameters.
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // TableView Code
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return 5
        case 3:
            return 3
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "AccountSettings", for: indexPath) as? AccountSettingsTableViewCell {
                cell.settingLabel?.text = settingLabels[indexPath.section][indexPath.row]
                return cell
            }
        case 3:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "GeneralSettings", for: indexPath) as? GeneralSettingsTableViewCell {
                cell.settingLabel?.text = settingLabels[indexPath.section][indexPath.row]
                return cell
            }
        case 4:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LogoutCell", for: indexPath) as? LogoutCellTableViewCell {
                return cell
            }
        default:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as? HeaderCellTableViewCell {
                cell.headerLabel?.text = settingLabels[indexPath.section][indexPath.row]
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 3:
            print(indexPath.row)
        case 4:
            PFUser.logOut()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let welcomeViewController = storyboard.instantiateInitialViewController()
            self.present(welcomeViewController!, animated: true, completion: nil)
        default:
            return
        }
    }
    
    
}
