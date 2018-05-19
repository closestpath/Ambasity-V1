//
//  SupportViewController.swift
//  Ambasity V1
//
//  Created by Zak on 4/15/18.
//  Copyright © 2018 ClosestPath. All rights reserved.
//

import UIKit

class SupportViewController: UIViewController {
    
// View Initializers
    private let cancelButton: UIButton = {
        let button = UIButton()
        
        let buttonTitle = NSMutableAttributedString(string: "Cancel", attributes:
            [NSAttributedStringKey.font: UIFont(name: "Avenir-Medium", size: 20)!,
             NSAttributedStringKey.foregroundColor: UIColor.darkGray]
        )
        
        button.setAttributedTitle(buttonTitle, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(cancelButton_TouchUpInside), for: .touchUpInside)
        
        return button
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "ambasityLogo"))
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Need help? Contact our Customer Support Team, available 24/7."
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: "Avenir-Medium", size: 25)
        label.textColor = .darkGray
        
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        label.numberOfLines = 2
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let webContactButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "web"), for: .normal)
        button.addTarget(self, action: #selector(webContactButton_TouchUpInside), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(lessThanOrEqualToConstant: 256).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        return button
    }()
    
    private let textContactButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "text"), for: .normal)
        button.addTarget(self, action: #selector(textContactButton_TouchUpInside), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(lessThanOrEqualToConstant: 256).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        return button
    }()
    
    private let emailContactButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "email"), for: .normal)
        button.addTarget(self, action: #selector(emailContactButton_TouchUpInside), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(lessThanOrEqualToConstant: 256).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        return button
    }()
    
    private let webContactLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Web"
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: "Avenir-Medium", size: 20)
        label.textColor = .darkGray
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(lessThanOrEqualToConstant: 256).isActive = true
        
        return label
    }()
    
    private let textContactLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Text"
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: "Avenir-Medium", size: 20)
        label.textColor = .darkGray
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(lessThanOrEqualToConstant: 256).isActive = true
        
        return label
    }()
    
    private let emailContactLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Email"
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: "Avenir-Medium", size: 20)
        label.textColor = .darkGray
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(lessThanOrEqualToConstant: 256).isActive = true
        
        return label
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "slateBackground"))
        
        imageView.alpha = 0.35
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
// Main View Setup
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupContactButtons()
    }
    
// View Setup
    private func setupLayout() {
        view.addSubview(backgroundImageView)
        
        backgroundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        backgroundImageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        backgroundImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        view.addSubview(cancelButton)
        
        cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        
        view.addSubview(descriptionLabel)
        
        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -25).isActive = true
        descriptionLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 200).isActive = true
        descriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        
        view.addSubview(logoImageView)
        
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.4).isActive = true
        logoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        logoImageView.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -10).isActive = true
        
        view.sendSubview(toBack: backgroundImageView)
    }
    
    private func setupContactButtons() {
        let contactButtonStackView = UIStackView(arrangedSubviews: [webContactButton, textContactButton, emailContactButton])
        contactButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        contactButtonStackView.distribution = .fillEqually
        contactButtonStackView.axis = .horizontal
        
        view.addSubview(contactButtonStackView)
        contactButtonStackView.topAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        contactButtonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        contactButtonStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        contactButtonStackView.heightAnchor.constraint(lessThanOrEqualToConstant: 256).isActive = true
     
        
        let contactLabelStackView = UIStackView(arrangedSubviews: [webContactLabel, textContactLabel, emailContactLabel])
        contactLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        contactLabelStackView.distribution = .fillEqually
        contactLabelStackView.axis = .horizontal
        
        view.addSubview(contactLabelStackView)
        contactLabelStackView.topAnchor.constraint(equalTo: contactButtonStackView.bottomAnchor, constant: 15).isActive = true
        contactLabelStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        contactLabelStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        contactLabelStackView.heightAnchor.constraint(lessThanOrEqualToConstant: 256).isActive = true
    }
    
// Button Targets
    @objc private func cancelButton_TouchUpInside() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func webContactButton_TouchUpInside() {
        UIApplication.shared.open(URL(string: "https://www.ambasity.com/contact-us.html")!, options: [:], completionHandler: nil)
    }
    
    @objc private func textContactButton_TouchUpInside() {
        UIApplication.shared.open(URL(string: "sms:330-571-0916")!, options: [:], completionHandler: nil)
    }
    
    @objc private func emailContactButton_TouchUpInside() {
        UIApplication.shared.open(URL(string: "mailto:support@closestpath.com")!, options: [:], completionHandler: nil)
    }
}
