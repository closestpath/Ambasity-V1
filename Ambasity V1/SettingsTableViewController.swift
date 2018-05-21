//
//  SettingsTableViewController.swift
//  Ambasity V1
//
//  Created by Zak on 4/15/18.
//  Copyright © 2018 ClosestPath. All rights reserved.
//

import UIKit
import Parse

class SettingsTableViewController: UITableViewController, UINavigationControllerDelegate, SettingDelegate {
    
    internal var user: User?
    
    internal var profileImage = #imageLiteral(resourceName: "user256")
    
    let settings = [
        ["Profile Image"],
        ["Username", "Email", "Phone", "Bio", "Message"],
        ["Payment", "Change Password", "Support"],
        ["Log Out"]
    ]
    
// View Initializers
    private let cancelButton: UIButton = {
        let button = UIButton()
        
        let buttonTitle = NSMutableAttributedString(string: "Cancel", attributes:
            [NSAttributedStringKey.font: UIFont(name: "Avenir-Medium", size: 20)!,
             NSAttributedStringKey.foregroundColor: UIColor.darkGray]
        )
        
        button.setAttributedTitle(buttonTitle, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        
        let buttonTitle = NSMutableAttributedString(string: "Save", attributes:
            [NSAttributedStringKey.font: UIFont(name: "Avenir-Medium", size: 20)!,
             NSAttributedStringKey.foregroundColor: UIColor.darkGray]
        )
        
        button.setAttributedTitle(buttonTitle, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
// Main View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        setupNavigationBar()
        tableView?.backgroundColor = UIColor(white: 0.9, alpha: 1)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        user?.getUserData()
        navigationController?.navigationBar.opaqueNavigationBar()
        navigationController?.navigationBar.barTintColor = UIColor(white: 0.9, alpha: 1)
    }

   
// Table View Protocols
    override func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings[section].count
    }
    
    // Row View
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let item = indexPath.item
        
        switch section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCellId", for: indexPath) as! ProfileSettingsTableViewCell
            cell.profileImage = profileImage
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "generalCellId", for: indexPath) as! GeneralSettingsTableViewCell
            cell.delegate = self
            switch item {
            case 0:
                cell.setting = .Username
                cell.inputText = user?.username
            case 1:
                cell.setting = .Email
                cell.inputText = user?.email
            case 2:
                cell.setting = .PhoneNumber
                cell.inputText = user?.phoneNumber
            case 3:
                cell.setting = .Bio
                cell.inputText = user?.bio
            case 4:
                cell.setting = .Message
                cell.inputText = user?.message
            default:
                cell.setting = .Username
            }
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "accountCellId", for: indexPath) as! AccountSettingsTableViewCell
            cell.setting = settings[section][item]
            cell.accessoryType = .disclosureIndicator
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "accountCellId", for: indexPath) as! AccountSettingsTableViewCell
            cell.setting = "Log Out"
            cell.labelColor = .red
            return cell
        default: break
        }
        
        return UITableViewCell()
    }
    
    // Row Height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        var height: CGFloat
        
        switch section {
        case 0: height = 100
        default: height = 50
        }
        
        return height
    }
    
    // Footer View
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    // Footer Height
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        var height: CGFloat
        
        switch section {
        case 0: height = 0
        default: height = 25
        }
        
        return height
    }
    
    // Selection Handlers
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let item = indexPath.item
        
        switch section {
        case 0: changePictureButton_TouchUpInside()
        case 2:
            switch item {
            case 0:
                self.performSegue(withIdentifier: "toPayment", sender: nil)
            case 1:
                self.performSegue(withIdentifier: "toPasswordChange", sender: nil)
            case 2:
                let storyboard = UIStoryboard(name: "Support", bundle: nil)
                let supportViewController = storyboard.instantiateInitialViewController()!
                self.present(supportViewController, animated: true)
            default: break
            }
        case 3: logoutButton_TouchUpInside()
        default: break
        }
    }
    
// View Setup
    private func registerCells() {
        tableView?.register(ProfileSettingsTableViewCell.self, forCellReuseIdentifier: "profileCellId")
        tableView?.register(GeneralSettingsTableViewCell.self, forCellReuseIdentifier: "generalCellId")
        tableView?.register(AccountSettingsTableViewCell.self, forCellReuseIdentifier: "accountCellId")
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        cancelButton.addTarget(self, action: #selector(cancelButton_TouchUpInside), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        saveButton.addTarget(self, action: #selector(saveButton_TouchUpInside), for: .touchUpInside)

        
    }
    
// Button Targets
    @objc private func cancelButton_TouchUpInside() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveButton_TouchUpInside() {
        view.endEditing(true)
        
        PFUser.current()?.username = user?.username
        PFUser.current()?.email = user?.email
        if let phoneNumber: String = user?.phoneNumber {
            PFUser.current()?["phoneNumber"] = phoneNumber
        }
        if let bio: String = user?.bio {
            PFUser.current()?["bio"] = bio
        }
        if let message: String = user?.message {
            PFUser.current()?["personalizedMessage"] = message
        }
        
        PFUser.current()?.saveInBackground(block: { (success, error) in
            if error != nil {
                
                self.displayAlert(title: "Error", message: "Parse Server: \(error!.localizedDescription)")
                
            } else {
                
                self.dismiss(animated: true, completion: nil)
                
            }
        })
    }
    
    @objc private func changePictureButton_TouchUpInside() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc private func logoutButton_TouchUpInside() {
        PFUser.logOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let welcomeViewController = storyboard.instantiateInitialViewController()!
        self.present(welcomeViewController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPayment" {
            
            guard let paymentViewController = segue.destination as? PaymentViewController else { return }
            guard let unwrappedUser = user else { return }
            paymentViewController.user = unwrappedUser
            
        }
    }
    
}

// Image Picker Protocols
extension SettingsTableViewController: UIImagePickerControllerDelegate {
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            profileImage = image
            tableView?.reloadData()

            if let imageData = UIImagePNGRepresentation(image) {
                
                PFUser.current()?["profileImage"] = PFFile(name: "profile.png", data: imageData)
                
                PFUser.current()?.saveInBackground(block: { (success, error) in

                    if error != nil {
                        
                        self.displayAlert(title: "Error", message: "Parse Server: \(error!.localizedDescription)")
                        
                    }
                })
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }

// Setting Delegate Protocols
    func settingValueSelected(setting: Setting, value: String) {
        switch setting {
        case .Username: user?.username = value
        case .Email: user?.email = value
        case .PhoneNumber: user?.phoneNumber = value
        case .Bio: user?.bio = value
        case .Message: user?.message = value
        default: break
        }
    }
}
