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
    
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    @IBOutlet var coverImage: UIImageView!
    @IBOutlet var brandNameLabel: UILabel!
    @IBOutlet var remainingDownloadsLabel: UILabel!
    @IBOutlet var brandDescriptionLabel: UILabel!
    @IBOutlet var representingSwitch: UISwitch!
    
    var brandName: String!
    var brandDescription: String!
    var brandId: String!
    var isRepresenting: Bool = false
    
    @IBAction func representingSwitched(_ sender: Any) {
        if isRepresenting {
            displayAlert(title: "Please Confirm", message: "You have selected to stop representing " + brandName + ". Do you wish to proceed?")
            isRepresenting = false
        } else {
            displayAlert(title: "Please Confirm", message: "You have selected to represent " + brandName + ". Do you wish to proceed?")
            isRepresenting = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.largeTitleDisplayMode = .never
        
        // Do any additional setup after loading the view.
        
        // Setting up the activity indicator that signals the app is looking for a logged-in user.
        // Defining the center point.
        activityIndicator.center.x = self.view.center.x
        activityIndicator.center.y = self.view.center.y
        activityIndicator.hidesWhenStopped = true
        
        // Defining the color/style.
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        
        // Adding the activity indicator to the UIView.
        view.addSubview(activityIndicator)
        // Starts animating.
        activityIndicator.startAnimating()
        // Ignores user interaction events until the app has stopped looking for a logged-in user.
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        
        self.navigationItem.title = brandName
        brandNameLabel.text = brandName
        brandDescriptionLabel.text = brandDescription
        
        // Querying the brand information.
        // Defining the query parameters.
        let query = PFQuery(className: "Representing")
        query.whereKey("Brand", equalTo: PFObject(withoutDataWithClassName:"Brand", objectId:brandId))
        
        query.findObjectsInBackground { (objects, error) in
            if let representations = objects {
                
                if representations.count == 0 {
                    
                    // If no objects are found.
                    self.isRepresenting = false
                    self.representingSwitch.isOn = false
                    
                } else {
                    for representation in representations {
                        if let ambassador = representation["Ambassador"] as? PFObject {
                            if ambassador.objectId == PFUser.current()!.objectId {
                                self.isRepresenting = true
                                self.representingSwitch.isOn = true
                            } else {
                                self.isRepresenting = false
                                self.representingSwitch.isOn = false
                            }
                        }
                    }
                }
                
                // Stops ignoring interaction events.
                UIApplication.shared.endIgnoringInteractionEvents()
                // Stops the activity indicator.
                self.activityIndicator.stopAnimating()
                
            }
        }
    }
    
    func displayAlert (title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }

}
