//
//  ProfileSettingsTableViewCell.swift
//  Ambasity V1
//
//  Created by Zak on 4/15/18.
//  Copyright © 2018 ClosestPath. All rights reserved.
//

import UIKit

class ProfileSettingsTableViewCell: UITableViewCell {
    
    var profileImage: UIImage? {
        didSet {
            guard let unwrappedProfileImage = profileImage else { return }
            profileImageView.image = unwrappedProfileImage
        }
    }
    
    internal let profileImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.layer.cornerRadius = 36
        imageView.layer.borderWidth = 1.5
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.masksToBounds = true
    
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let settingLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Change Picture"
        label.font = UIFont(name: "Avenir-Medium", size: 20)
        label.textColor = .darkGray
        
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        
        addSubview(profileImageView)
        
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.75).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25).isActive = true
        
        addSubview(settingLabel)
        
        settingLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        settingLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.75).isActive = true
        settingLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.5).isActive = true
        settingLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 25).isActive = true
        
    }
}
