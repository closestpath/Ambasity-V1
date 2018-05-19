//
//  BrandsViewController.swift
//  Ambasity V1
//
//  Created by Zak on 11/28/17.
//  Copyright © 2017 ClosestPath. All rights reserved.
//

import UIKit
import Parse

class BrandsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let overlay = UIView()
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    @IBOutlet var table: UITableView!
    
    var brands = [Brand]()
    
// Main View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getBrandInfo()
        view.startActivityIndicator(overlay: overlay, activityIndicator: activityIndicator)
    }
    
// Table View Protocols
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brands.count
    }
    
    // Row View
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainFeedTableViewCell
        cell.nameLabel.text = brands[indexPath.row].name
        cell.descriptionLabel.text = brands[indexPath.row].description
        /*brandImageData[indexPath.section].getDataInBackground { (data, error) in
         if let imageData = data {
         if let logo = UIImage(data: imageData) {
         //cell.icon.image = logo
         }
         }
         }*/
        return cell
    }
    
    // Row Height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // Footer View
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    // Selection Handlers
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "toBrandInfo", sender: indexPath.row)
    }

    
// View Setup
    private func getBrandInfo() {
        let query = PFQuery(className: "Brand")
        query.findObjectsInBackground(block: { (objects, error) in
            if error == nil {
                
                if objects != nil {
                    
                    for object in objects! {
                        
                        guard let objectId = object.objectId else { return }
                        guard let name = object["Name"] as? String else { return }
                        guard let description = object["Description"] as? String else { return }
                        guard let logo = object["iPhoneLogo"] as? PFFile else { return }
                        guard let link = object["Link"] as? String else { return }
                        
                        let brand = Brand(objectId: objectId, name: name, description: description, logo: logo, link: link)
                        
                        self.brands.append(brand)
                        self.table.reloadData()
                    }
                    self.view.stopActivityIndicator(overlay: self.overlay, activityIndicator: self.activityIndicator)
                }
            }
            else {
                self.displayAlert(title: "Network Error", message: "There was a problem accessing the brands. Please check your network connection.")
            }
        })
    }

// Button Targets
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toBrandInfo" {
            
            guard let brandInfoViewController = segue.destination as? BrandInfoViewController else { return }
            guard let selectedRow = sender as? Int else { return }
            
            brandInfoViewController.brand = brands[selectedRow]
            
        }
    }
}
