//
//  ProfileSettingsTableViewCell.swift
//  Ambasity V1
//
//  Created by Zak on 4/15/18.
//  Copyright © 2018 ClosestPath. All rights reserved.
//

import UIKit

class AccountSettingsTableViewCell: UITableViewCell {
    
    var setting: String? {
        
        didSet {
            guard let unwrappedSetting = setting else { return }
            settingLabel.text = unwrappedSetting
        }
        
    }
    
    var labelColor: UIColor? {
        
        didSet {
            guard let unwrappedLabelColor = labelColor else { return }
            settingLabel.textColor = unwrappedLabelColor
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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(settingLabel)
        
        settingLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        settingLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
        settingLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        settingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25).isActive = true
    }
}
