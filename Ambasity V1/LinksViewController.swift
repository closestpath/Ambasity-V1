//
//  LinksViewController.swift
//  Ambasity V1
//
//  Created by Zak on 2/10/18.
//  Copyright © 2018 ClosestPath. All rights reserved.
//

import UIKit
import Parse

class LinksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var links = [String]()
    var refresher : UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Updating the table once the view has initially loaded.
        updateTable()
        // Adding the refreshing spinner.
        refresher.addTarget(self, action: #selector(LinksViewController.updateTable), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // The amount of table rows is equal to the number of queried links.
        return links.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Defining the cell object.
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        // Changing the cell's text to the corresponding link in the queried links array.
        cell.textLabel?.text = links[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Determines which row was selected.
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Defining the message and url to share.
        let messageToShare = "Check out this new app!"
        let URLToShare = NSURL(string: "https://www.google.com/")
        
        // Both parameters must be combined into an array to be used as a parameter for the UIActivityViewController.
        let messageObject : [Any] = [messageToShare, URLToShare!]
        
        // Creating and displaying the UIActivityViewController.
        let shareActivity = UIActivityViewController(activityItems: messageObject, applicationActivities: nil)
        self.present(shareActivity, animated: true, completion: nil)
        
    }
    
    // Creates an alert with title and message parameters.
    func displayAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @objc func updateTable() {
        
        // Defining the query to select only the rows from the Representing Table where the Ambassador is the current user.
        let query = PFQuery(className: "Representing")
        query.whereKey("Ambassador", equalTo: PFUser.current()!)
        
        // Running the query.
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                
                if let objects = objects {
                    // Clears the old data.
                    self.links.removeAll()
                    
                    for object in objects {
                        // Adds each new link to our array.
                        self.links.append(object.objectId!)
                        
                    }
                    
                    // Reloads the table once all links have been added.
                    if self.links.count == objects.count {

                        self.tableView.reloadData()
                        self.refresher.endRefreshing()
                    }
                    
                }
            } else {
                // Displays any errors.
                self.displayAlert(title: "Error", message: error!.localizedDescription)
                
            }
            
            
        }
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
