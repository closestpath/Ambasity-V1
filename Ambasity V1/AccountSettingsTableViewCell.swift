//
//  AccountSettingsTableViewCell.swift
//  Ambasity V1
//
//  Created by Zak on 3/29/18.
//  Copyright © 2018 ClosestPath. All rights reserved.
//

import UIKit

class AccountSettingsTableViewCell: UITableViewCell {
    
    @IBOutlet var settingLabel: UILabel!
    
    @IBOutlet var settingTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func settingTextField_EditingDidEnd(_ sender: Any) {
        
    }
    
}
