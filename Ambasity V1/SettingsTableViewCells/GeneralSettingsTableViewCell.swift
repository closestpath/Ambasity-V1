//
//  GeneralSettingsTableViewCell.swift
//  Ambasity V1
//
//  Created by Zak on 4/15/18.
//  Copyright © 2018 ClosestPath. All rights reserved.
//

import UIKit

class GeneralSettingsTableViewCell: UITableViewCell {
    
    let generalSettings = ["Username", "Email", "Phone", "Bio", "Message", "Venmo", "PayPal"]
    
    var delegate: SettingDelegate?
    var setting: Setting! {
        didSet {
            switch setting {
            case .Username:
                settingLabel.text = generalSettings[0]
                inputTextField.placeholder = generalSettings[0]
            case .Email:
                settingLabel.text = generalSettings[1]
                inputTextField.placeholder = generalSettings[1]
                inputTextField.keyboardType = .emailAddress
            case .PhoneNumber:
                settingLabel.text = generalSettings[2]
                inputTextField.placeholder = generalSettings[2]
                inputTextField.keyboardType = .numberPad
            case .Bio:
                settingLabel.text = generalSettings[3]
                inputTextField.placeholder = generalSettings[3]
            case .Message:
                settingLabel.text = generalSettings[4]
                inputTextField.placeholder = generalSettings[4]
            case .Venmo:
                settingLabel.text = generalSettings[5]
                inputTextField.placeholder = generalSettings[0]
            case .PayPal:
                settingLabel.text = generalSettings[6]
                inputTextField.placeholder = generalSettings[0]
            default: break
            }
        }
    }
    
    var inputText: String? {
        didSet {
            guard let unwrappedInputText = inputText else { return }
            inputTextField.text = unwrappedInputText
        }
    }
    
    private let settingLabel: UILabel = {
        let label = UILabel()
        
        label.backgroundColor = .clear
        
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont(name: "Avenir-Medium", size: 20)
        label.textColor = .darkGray
        
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let inputTextField: UITextField = {
        let textField = UITextField()
        
        textField.backgroundColor = .clear
        
        textField.textAlignment = NSTextAlignment.left
        textField.font = UIFont(name: "Avenir-Medium", size: 20)
        textField.textColor = .darkGray
        
        textField.borderStyle = .none
        
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 10
        
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private let bottomBorder: UIView = {
        let view = UIView()
        
        view.backgroundColor = .darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
        setupTextView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(settingLabel)
        
        settingLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        settingLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4).isActive = true
        settingLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        settingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25).isActive = true
        
        addSubview(inputTextField)
        
        inputTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        inputTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        inputTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        
//        addSubview(bottomBorder)
//        
//        bottomBorder.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
//        bottomBorder.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
//        bottomBorder.topAnchor.constraint(equalTo: inputTextField.bottomAnchor).isActive = true
//        bottomBorder.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
    }
    
    private func setupTextView() {
        
        inputTextField.delegate = self
        let doneButtonToolBar = UIToolbar.init()
        doneButtonToolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(doneButton_TouchUpInside))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        doneButtonToolBar.items = [flexibleSpace, doneButton]
        inputTextField.inputAccessoryView = doneButtonToolBar
        
    }
    
// Button Targets
    @objc private func doneButton_TouchUpInside() {
        endEditing(true)
    }
    
}

// TextView Protocols
extension GeneralSettingsTableViewCell: UITextFieldDelegate {
    
    internal func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        delegate?.settingValueSelected(setting: setting, value: textField.text!)
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
