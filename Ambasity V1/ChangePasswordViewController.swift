//
//  ChangePasswordViewController.swift
//  Ambasity V1
//
//  Created by Zak Zinda on 5/20/18.
//  Copyright © 2018 ClosestPath. All rights reserved.
//

import UIKit
import Parse

class ChangePasswordViewController: UIViewController {
    
    internal var user: User?
    
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
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Change Your Password"
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: "Avenir-Medium", size: 25)
        label.textColor = .darkGray
        
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let passwordTextField: DesignableTextField = {
        let textField = DesignableTextField()
        
        textField.placeholder = "New Password"
        textField.font = UIFont(name: "Avenir-Medium", size: 20)
        textField.textColor = .darkGray
        textField.isSecureTextEntry = true
        
        textField.borderStyle = .roundedRect
        textField.rightImage = #imageLiteral(resourceName: "passwordIcon")
        
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 10
        
        return textField
    }()
    
    private let confirmPasswordTextField: DesignableTextField = {
        let textField = DesignableTextField()
        
        textField.placeholder = "Confirm Password"
        textField.font = UIFont(name: "Avenir-Medium", size: 20)
        textField.textColor = .darkGray
        textField.isSecureTextEntry = true
        
        textField.borderStyle = .roundedRect
        textField.rightImage = #imageLiteral(resourceName: "passwordIcon")
        
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 10
        
        return textField
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "slateBackground"))
        
        imageView.alpha = 0.35
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupNavigationController()
    }
    
    
    // View Setup
    private func setupLayout() {
        [backgroundImageView, descriptionLabel, passwordTextField, confirmPasswordTextField].forEach { (v) in
            view.addSubview(v)
        }
        
        backgroundImageView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        descriptionLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 25, left: 20, bottom: 0, right: 20))
        
        passwordTextField.anchor(top: descriptionLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 25, left: 20, bottom: 0, right: 20))
        passwordTextField.setFixedSize(size: .init(width: 0, height: 50))
        
        confirmPasswordTextField.anchor(top: passwordTextField.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 15, left: 20, bottom: 0, right: 20))
        confirmPasswordTextField.setFixedSize(size: .init(width: 0, height: 50))
        
        view.sendSubview(toBack: backgroundImageView)
    }
    
    private func setupNavigationController() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        cancelButton.addTarget(self, action: #selector(cancelButton_TouchUpInside), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        saveButton.addTarget(self, action: #selector(saveButton_TouchUpInside), for: .touchUpInside)
        
        //navigationController?.navigationBar.transparentNavigationBar()
    }
    
    // Button Targets
    @objc private func cancelButton_TouchUpInside() {
        view.endEditing(true)
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func saveButton_TouchUpInside() {
        view.endEditing(true)
        
        guard let currentUser = PFUser.current() else { return }
        
        if passwordTextField.text!.isEmpty == false && confirmPasswordTextField.text!.isEmpty == false {
            let password = passwordTextField.text!
            let confirmPassword = confirmPasswordTextField.text!
            
            if (password != confirmPassword) {
                self.displayAlert(title: "Passwords Do Not Match", message: "Please re-enter the same password.")
                return
            } else {
                currentUser.password = password
            }
        } else {
            displayAlert(title: "Error", message: "Please input and confirm a new password.")
            return
        }
        
        
        currentUser.saveInBackground(block: { (success, error) in
            if error != nil {
                
                self.displayAlert(title: "Error", message: "Parse Server: \(error!.localizedDescription)")
                
            } else {
                
                self.dismiss(animated: true, completion: nil)
                
            }
        })
        
        navigationController?.popToRootViewController(animated: true)
    }
}
