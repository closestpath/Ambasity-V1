//
//  BrandInfoViewController.swift
//  Ambasity V1
//
//  Created by Zak on 11/28/17.
//  Copyright © 2017 ClosestPath. All rights reserved.
//

import UIKit
import Parse

class BrandInfoViewController: UIViewController {
    
    var brand: Brand?
    var representing: PFObject?
    var isRepresenting: Bool = false
    
    let overlay = UIView()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    fileprivate let defaultPreviewImages = [#imageLiteral(resourceName: "brandInfoDefault0"), #imageLiteral(resourceName: "brandInfoDefault1"), #imageLiteral(resourceName: "brandInfoDefault2"), #imageLiteral(resourceName: "brandInfoDefault3")]
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "slateBackground"))
        imageView.alpha = 0.35
        
        return imageView
    }()
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = .clear
        sv.bounces = false
        return sv
    }()
    
    private var collectionView: UICollectionView!
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        
        label.backgroundColor = .clear
        
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont(name: "Avenir-Heavy", size: 25)
        label.textColor = .black
        
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        label.numberOfLines = 1
        
        return label
    }()
    
    private let representButton: SubmitButton = {
        let button = SubmitButton()
        
        button.backgroundColor = .mainBlue
        button.cornerRadius = 22.5
        
        button.addTarget(self, action: #selector(representButton_TouchUpInside), for: .touchUpInside)
        
        return button
    }()
    
    private let downloadsLabel: UILabel = {
        let label = UILabel()
        
        label.backgroundColor = .clear
        
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont(name: "Avenir-MediumOblique", size: 20)
        label.textColor = .darkGray
        
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        label.numberOfLines = 1
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.backgroundColor = .clear
        
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont(name: "Avenir-Medium", size: 20)
        label.textColor = .darkGray
        
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        label.numberOfLines = 0
        
        return label
    }()
    
// Main View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        queryRepresenting()
        setupCollectionView()
        setupLayout()
        view.startActivityIndicator(overlay: overlay, activityIndicator: activityIndicator)
    }
    
// View Setup
    private func setupLayout() {
        self.navigationItem.title = brand?.name
        nameLabel.text = brand?.name
        setRepresentingButtonTitle(isRepresenting: isRepresenting)
        downloadsLabel.text = "Remaining Downloads: "
        descriptionLabel.text = brand?.description
        
        [backgroundImageView, scrollView].forEach {
            view.addSubview($0)
        }
        
        backgroundImageView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        
        view.sendSubview(toBack: backgroundImageView)
        
        [collectionView, nameLabel, representButton, downloadsLabel, descriptionLabel].forEach {
            scrollView.addSubview($0)
        }
        
        representButton.anchor(top: collectionView.bottomAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 20))
        
        representButton.setFixedSize(size: .init(width: 150, height: 45))
        
        nameLabel.anchor(top: representButton.topAnchor, leading: view.leadingAnchor, bottom: representButton.bottomAnchor, trailing: representButton.leadingAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 20))
        
        downloadsLabel.anchor(top: representButton.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 15, left: 20, bottom: 0, right: 0))
        
        descriptionLabel.anchor(top: downloadsLabel.bottomAnchor, leading: view.leadingAnchor, bottom: scrollView.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 15, left: 20, bottom: 50, right: 20))
    }
    
    private func setupCollectionView() {
        
        let frame: CGRect = CGRect(x: 0, y: 0, width: view.frame.width, height: (view.frame.height / 2))
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(BrandInfoCollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
    }
    
    private func setRepresentingButtonTitle(isRepresenting: Bool) {
        
        var titleText: String!
        
        if isRepresenting {
            titleText = "Unsubscribe"
        } else {
            titleText = "Represent"
        }
        
        let buttonTitle = NSMutableAttributedString(string: titleText, attributes:
            [NSAttributedStringKey.font: UIFont(name: "Avenir-Medium", size: 18)!,
             NSAttributedStringKey.foregroundColor: UIColor.white]
        )
        
        let pressedButtonTitle = NSMutableAttributedString(string: titleText, attributes:
            [NSAttributedStringKey.font: UIFont(name: "Avenir-Medium", size: 18)!,
             NSAttributedStringKey.foregroundColor: UIColor.init(white: 0.9, alpha: 1)]
        )
        
        representButton.setAttributedTitle(buttonTitle, for: .normal)
        representButton.setAttributedTitle(pressedButtonTitle, for: .highlighted)
    }
    
// Button Targets
    @objc private func representButton_TouchUpInside() {
        
        self.view.startActivityIndicator(overlay: overlay, activityIndicator: activityIndicator)
        
        if isRepresenting {
            isRepresenting = false
            setRepresentingButtonTitle(isRepresenting: isRepresenting)
            
            if let parseRepresenting = representing {
                
                parseRepresenting.deleteInBackground { (success, error) in
                    self.view.stopActivityIndicator(overlay: self.overlay, activityIndicator: self.activityIndicator)
                    if error == nil {
                        self.displayAlert(title: "Unsubscribe Successful", message: "You are no longer representing " + (self.brand?.name)!)
                    } else {
                        self.displayAlert(title: "Error", message: "Parse Error: \(error!.localizedDescription)")
                    }
                }
            }
            
        } else {
            isRepresenting = true
            setRepresentingButtonTitle(isRepresenting: isRepresenting)
            
            let parseRepresenting = PFObject(className: "Representing")
            parseRepresenting["Brand"] = PFObject(withoutDataWithClassName: "Brand", objectId: brand?.objectId)
            parseRepresenting["Ambassador"] = PFObject(withoutDataWithClassName: "_User", objectId: PFUser.current()!.objectId)
            
            parseRepresenting.saveInBackground { (success, error) in
                self.view.stopActivityIndicator(overlay: self.overlay, activityIndicator: self.activityIndicator)
                if error == nil {
                    self.displayAlert(title: "Success", message: "You have successfully signed up to represent " + (self.brand?.name)!)
                    self.representing = parseRepresenting
                } else {
                    self.displayAlert(title: "Error", message: "Parse Error: \(error!.localizedDescription)")
                }
            }
        }
        
    }
    
// Parse Server Calls
    private func queryRepresenting() {
        let query = PFQuery(className: "Representing")
        query.whereKey("Brand", equalTo: PFObject(withoutDataWithClassName:"Brand", objectId: brand?.objectId))
        query.whereKey("Ambassador", equalTo: PFObject(withoutDataWithClassName: "_User", objectId: PFUser.current()!.objectId))
        
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                
                if objects != nil {
                    
                    if objects!.count != 1 {
                        
                        self.isRepresenting = false
                        self.setRepresentingButtonTitle(isRepresenting: self.isRepresenting)
                        self.view.stopActivityIndicator(overlay: self.overlay, activityIndicator: self.activityIndicator)
                        
                    } else {
                        
                        self.representing = objects![0]
                        self.isRepresenting = true
                        self.setRepresentingButtonTitle(isRepresenting: self.isRepresenting)
                        self.view.stopActivityIndicator(overlay: self.overlay, activityIndicator: self.activityIndicator)
                        
                    }
                }
                
            } else {
                self.displayAlert(title: "Error", message: "Parse Server: \(error!.localizedDescription)")
            }
            
        }
    }
}
extension BrandInfoViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // Collection View Protocols
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return defaultPreviewImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: (self.view.frame.height / 2))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! BrandInfoCollectionViewCell
        cell.previewImage = defaultPreviewImages[indexPath.row]
        return cell
    }
}
