//
//  BrandsViewController.swift
//  Ambasity V1
//
//  Created by Zak on 11/28/17.
//  Copyright © 2017 ClosestPath. All rights reserved.
//

import UIKit
import Parse
import CoreData

class BrandsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate {
    
    @IBOutlet var table: UITableView!
    
    var brandNames = [String]()
    var brandDescriptions = [String]()
    var brandIds = [String]();
    var brandImageData = [PFFile]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brandNames.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainFeedTableViewCell
        cell.nameLabel.text = brandNames[indexPath.row]
        cell.descriptionLabel.text = brandDescriptions[indexPath.row]
        /*brandImageData[indexPath.section].getDataInBackground { (data, error) in
            if let imageData = data {
                if let logo = UIImage(data: imageData) {
                    //cell.icon.image = logo
                }
            }
        }*/
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "toBrandInfo", sender: indexPath.row)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        /* Setup the Search Controller
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search Apps"
        navigationItem.searchController = searchController
        definesPresentationContext = true*/
        
        let query = PFQuery(className: "Brand")
        query.findObjectsInBackground(block: { (objects, error) in
            if error == nil {
                if let brands = objects {
                    
                    for brand in brands {
                        
                        if let brandName = brand["Name"] as? String {
                            self.brandNames.append(brandName)
                        }
                        if let brandDescription = brand["Description"] as? String {
                            self.brandDescriptions.append(brandDescription)
                        }
                        if let brandId = brand.objectId {
                            self.brandIds.append(brandId)
                        }
                        if let brandImageData = brand["iPhoneLogo"] as? PFFile {
                            self.brandImageData.append(brandImageData)
                        }
                        self.table.reloadData()
                    }
                }
            }
            else {
                self.displayAlert(title: "Network Error", message: "There was a problem accessing the brands. Please check your network connection.")
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBrandInfo" {
            let brandInfoViewController = segue.destination as! BrandInfoViewController
            if let selectedBrand = sender as? Int {
                brandInfoViewController.brandName = brandNames[selectedBrand]
                brandInfoViewController.brandDescription = brandDescriptions[selectedBrand]
                brandInfoViewController.brandId = brandIds[selectedBrand]
            }
        }
    }
    
    func displayAlert (title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension BrandsViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
    }
}
