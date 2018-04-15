//
//  SignUpCell.swift
//  Ambasity V1
//
//  Created by Zak on 4/11/18.
//  Copyright © 2018 ClosestPath. All rights reserved.
//

import UIKit

extension UITextView {
    
    func setBottomBorder() {
        
    }
    
}

class SignUpCell: UICollectionViewCell {
    
    var form: Form? {
        
        didSet {
            guard let unwrappedForm = form else { return }
            
            headerLabel.text = unwrappedForm.headerText
            descriptionLabel.text = unwrappedForm.descriptionText

        }

    }
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        
        label.backgroundColor = .clear
        
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: "Avenir-Medium", size: 30)
        label.textColor = .white
        
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5

        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.backgroundColor = .clear
        
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: "Avenir-Medium", size: 20)
        label.textColor = .white
        
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        label.numberOfLines = 0
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .mainBlue
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        
        addSubview(headerLabel)
        
        headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
        headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30).isActive = true
        headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 50).isActive = true
        headerLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        addSubview(descriptionLabel)
        
        descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 10).isActive = true
        descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: centerYAnchor, constant: -125).isActive = true
        
    }
}
