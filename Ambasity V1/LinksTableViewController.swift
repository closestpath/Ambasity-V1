//
//  LinksTableViewController.swift
//  Ambasity V1
//
//  Created by Zak on 5/16/18.
//  Copyright © 2018 ClosestPath. All rights reserved.
//

import UIKit
import Parse

class LinksTableViewController: UITableViewController {
    
    private var names = [String]()
    private var links = [String]()
    private var personalizedMessage: String?
    
    internal var refresherControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(getCampaignData), for: UIControlEvents.valueChanged)
        return rc
    }()
    
// Main Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCampaignData()
        self.navigationItem.title = "My Campaigns"
        tableView?.addSubview(refresherControl)
    }
    
// Table View Protocols
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    // Row View
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        cell.textLabel?.text = names[indexPath.row]
        return cell
    }
    
    // Selection Handlers
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var messageObject = [Any]()
        
        if personalizedMessage != nil {
            messageObject.append(personalizedMessage!)
        }
        
        let URLToShare = NSURL(string: links[indexPath.row])
        messageObject.append(URLToShare!)

        let shareActivity = UIActivityViewController(activityItems: messageObject, applicationActivities: nil)
        self.navigationController?.present(shareActivity, animated: true, completion: nil)
    }
    
// Parse Server Calls
    @objc private func getCampaignData() {
        let query = PFQuery(className: "Representing")
        query.whereKey("Ambassador", equalTo: PFObject(withoutDataWithClassName: "_User", objectId: PFUser.current()!.objectId))
        
        names.removeAll()
        links.removeAll()
        
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                if objects != nil {
                    
                    for object in objects! {
                        
                        guard let unfetchedAmbassador = object["Ambassador"] as? PFUser else { return }
                        unfetchedAmbassador.fetchIfNeededInBackground(block: { (ambassador, error) in
                            if error == nil {
                                if ambassador != nil {
                                    if let message = ambassador!["personalizedMessage"] as? String {
                                        self.personalizedMessage = message
                                    }
                                }
                            } else {
                                self.displayAlert(title: "Error", message: "Parse Error: \(error!.localizedDescription)")
                            }
                        })
                        
                        guard let unfetchedBrand = object["Brand"] as? PFObject else { return }
                        unfetchedBrand.fetchIfNeededInBackground(block: { (brand, error) in
                            if error == nil {
                                if brand != nil {
                                    let name = brand!["Name"] as! String
                                    let link = brand!["Link"] as! String
                                    
                                    self.names.append(name)
                                    self.links.append(link)
                                    self.tableView?.reloadData()
                                }
                            } else {
                                self.displayAlert(title: "Error", message: "Parse Error: \(error!.localizedDescription)")
                            }
                        })
                        /*
                         let branchLink = object!["BranchLink"] as! String
                         self.links.append(branchLink)
                         self.tableView?.reloadData()
                        */
                    }
                }
            } else {
                self.displayAlert(title: "Error", message: "Parse Error: \(error!.localizedDescription)")
            }
            self.refresherControl.endRefreshing()
        }
    }
    
}
