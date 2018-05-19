//
//  PaymentViewController.swift
//  Ambasity V1
//
//  Created by Zak on 4/27/18.
//  Copyright © 2018 ClosestPath. All rights reserved.
//

import UIKit
import Parse

class PaymentViewController: UIViewController, SettingDelegate {
    
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
        
        label.text = "Choose Your Payment Method"
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: "Avenir-Medium", size: 25)
        label.textColor = .darkGray
        
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let paymentTableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.bounces = false
        
        return tableView
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
        setupNavigationController()
        setupTableView()
    }
    
    
// View Setup
    private func setupLayout() {
        view.addSubview(backgroundImageView)
        
        backgroundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        backgroundImageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        backgroundImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        view.addSubview(descriptionLabel)
        
        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
    }
    
    private func setupNavigationController() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        cancelButton.addTarget(self, action: #selector(cancelButton_TouchUpInside), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        saveButton.addTarget(self, action: #selector(saveButton_TouchUpInside), for: .touchUpInside)
        
        navigationController?.navigationBar.transparentNavigationBar()
    }
    
    private func setupTableView() {
        paymentTableView.delegate = self
        paymentTableView.dataSource = self
        paymentTableView.register(GeneralSettingsTableViewCell.self, forCellReuseIdentifier: "paymentCellId")
        
        paymentTableView.backgroundColor = .clear
        
        view.addSubview(paymentTableView)
        
        paymentTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        paymentTableView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 15).isActive = true
        paymentTableView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        paymentTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
// Button Targets
    @objc private func cancelButton_TouchUpInside() {
        view.endEditing(true)
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func saveButton_TouchUpInside() {
        view.endEditing(true)
        
        if let venmoId: String = user?.venmoId {
            PFUser.current()?["venmoId"] = venmoId
        }
        if let paypalUsername: String = user?.paypalUsername {
            PFUser.current()?["paypalUsername"] = paypalUsername
        }

        PFUser.current()?.saveInBackground(block: { (success, error) in
            if error != nil {

                self.displayAlert(title: "Error", message: "Parse Server: \(error!.localizedDescription)")

            } else {

                self.dismiss(animated: true, completion: nil)

            }
        })
        
        navigationController?.popToRootViewController(animated: true)
    }
}

// TableView Delegate Protocols
extension PaymentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    // Row Height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    // Row View
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "paymentCellId", for: indexPath) as! GeneralSettingsTableViewCell
        
        cell.backgroundColor = .clear
        cell.delegate = self
        switch indexPath.row {
        case 0:
            cell.setting = .Venmo
            cell.inputText = user?.venmoId
        case 1:
            cell.setting = .PayPal
            cell.inputText = user?.paypalUsername
        default:
            break
        }
        cell.selectionStyle = .none
        return cell
    }
    
// Setting Delegate Protocols
    func settingValueSelected(setting: Setting, value: String) {
        switch setting {
        case .Venmo: user?.venmoId = value
        case .PayPal: user?.paypalUsername = value
        default: break
        }
    }
    
}
