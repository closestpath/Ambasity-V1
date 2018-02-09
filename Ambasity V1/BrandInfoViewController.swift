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
    
    @IBOutlet var brandNameLabel: UILabel!
    @IBOutlet var brandDescriptionLabel: UILabel!
    @IBOutlet var brandLogoView: UIImageView!
    @IBOutlet var representLabel: UILabel!
    @IBOutlet var representSwitch: UISwitch!
    @IBOutlet var activeSinceLabel: UILabel!
    @IBOutlet var numAmbassadorsLabel: UILabel!
    @IBOutlet var numDownloadsLabel: UILabel!
    
    var brandName: String = ""
    var brandId: String = ""
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    @IBAction func representIsSwitched(_ sender: Any) {
        if representSwitch.isOn {
            let represent = PFObject(className: "Representing")
            represent["Ambassador"] = PFUser.current()
            represent["Brand"] = brandId
            represent.saveInBackground()
        }
        else {
            let query = PFQuery(className: "Representing")
            query.whereKey("Ambassador", equalTo: PFUser.current()!)
            query.whereKey("Brand", equalTo: brandId)
            query.findObjectsInBackground(block: { (objects, error) in
                if let objects = objects {
                    for object in objects {
                        object.deleteInBackground()
                    }
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = brandName
        brandNameLabel.text = brandName
        representLabel.text = "Represent " + brandName
        numAmbassadorsLabel.text = "0"
        numDownloadsLabel.text = "0"
        let query = PFQuery(className: "Brand")
        query.whereKey("Name", equalTo: brandName)
        query.findObjectsInBackground { (objects, error) in
            if let brands = objects {
                for brand in brands {
                    if let objectId = brand.objectId {
                        self.brandId = objectId
                    }
                    if let brandDescription = brand["Description"] as? String {
                        self.brandDescriptionLabel.text = brandDescription
                    }
                    if let logoData = brand["Image"] as? PFFile {
                        logoData.getDataInBackground(block: { (data, error) in
                            if let imageData = data {
                                if let logo = UIImage(data: imageData) {
                                    self.brandLogoView.image = logo
                                }
                            }
                        })
                    }
                    if let activeDate = brand.createdAt {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "MMMM yyyy"
                        let activeDateFormatted = formatter.string(from: activeDate)
                        self.activeSinceLabel.text = "Active Member Since "  + activeDateFormatted
                    }
                }
                let query = PFQuery(className: "Representing")
                query.whereKey("Brand", equalTo: self.brandId)
                query.whereKey("Ambassador", equalTo: PFUser.current()!)
                query.findObjectsInBackground(block: { (objects, error) in
                    if !(objects!.isEmpty) {
                        self.representSwitch.isOn = true
                    }
                    else {
                        self.representSwitch.isOn = false
                    }
                    
                })
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func startSpinner() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    @objc func stopSpinner() {
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
