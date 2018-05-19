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

        updateTable()
        // Adding the refreshing spinner.
        refresher.addTarget(self, action: #selector(LinksViewController.updateTable), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
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
    
    @objc private func updateTable() {
        
    }
}
