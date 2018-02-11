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

class BrandsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var brandNames = [String]()
    var brandDescriptions = [String]()
    var brandImageData = [PFFile]()
    var logoType : String!

    @IBOutlet var table: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brandNames.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BrandsFeedTableCellTableViewCell
        brandImageData[indexPath.row].getDataInBackground { (data, error) in
            if let imageData = data {
                if let logo = UIImage(data: imageData) {
                    cell.brandLogo.image = logo
                }
            }
        }
        cell.brandDescription.text = brandDescriptions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "toBrandInfo", sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            logoType = "iPadLogo"
        }
        else if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone {
            logoType = "iPadLogo"
        }
        
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
                        if let brandImageData = brand[self.logoType] as? PFFile {
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBrandInfo" {
            let brandInfoViewController = segue.destination as! BrandInfoViewController
            if let selectedBrand = sender as? Int {
                brandInfoViewController.brandName = brandNames[selectedBrand]
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func displayAlert (title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
