//
//  OnboardingCell.swift
//  Ambasity V1
//
//  Created by Zak on 4/11/18.
//  Copyright © 2018 ClosestPath. All rights reserved.
//

import UIKit

class OnboardingCell: UICollectionViewCell {
    
    var page: OnboardingPage? {
        
        didSet {
            guard let unwrappedPage = page else { return }
            
            onboardingImageView.image = UIImage(named: unwrappedPage.imageName)
            headerLabel.text = unwrappedPage.headerText
            bodyLabel.text = unwrappedPage.bodyText
            
            if (unwrappedPage.pageNumber == 2) {
                doneButton.isHidden = false
            }
            
        }
        
    }
    
    private let onboardingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 1.0
        return imageView
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        
        label.backgroundColor = .clear
        
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: "Avenir-Heavy", size: 25)
        label.textColor = .darkGray
        
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        
        label.backgroundColor = .clear
        
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: "Avenir-Medium", size: 20)
        label.textColor = .darkGray
        
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        label.numberOfLines = 0
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    internal let doneButton: UIButton = {
        let button = UIButton()
        
        let attributedString = NSMutableAttributedString(string: "Done", attributes:
            [NSAttributedStringKey.font : UIFont(name: "Avenir-Medium", size: 20)!,
             NSAttributedStringKey.foregroundColor : UIColor.red]
        )
        
        let highlightedString = NSMutableAttributedString(string: "Done", attributes:
            [NSAttributedStringKey.font : UIFont(name: "Avenir-Medium", size: 20)!,
             NSAttributedStringKey.foregroundColor : UIColor.red.withAlphaComponent(0.25)]
        )
        
        button.setAttributedTitle(attributedString, for: .normal)
        button.setAttributedTitle(highlightedString, for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        
        [headerLabel, onboardingImageView, bodyLabel, doneButton].forEach {
            addSubview($0)
        }
        
        headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
        headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30).isActive = true
        headerLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        headerLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true

        onboardingImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        onboardingImageView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 100).isActive = true
        onboardingImageView.bottomAnchor.constraint(equalTo: headerLabel.topAnchor, constant: -25).isActive = true
        
        onboardingImageView.widthAnchor.constraint(lessThanOrEqualToConstant: 256).isActive = true
        onboardingImageView.heightAnchor.constraint(equalTo: onboardingImageView.widthAnchor).isActive = true
        
        bodyLabel.anchor(top: headerLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 10, left: 20, bottom: 0, right: 20))
        
        doneButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -100).isActive = true
        
    }
    
}
