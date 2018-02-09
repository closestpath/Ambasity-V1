//
//  BrandsFeedTableCellTableViewCell.swift
//  Ambasity V1
//
//  Created by Zak on 12/27/17.
//  Copyright © 2017 ClosestPath. All rights reserved.
//

import UIKit

class BrandsFeedTableCellTableViewCell: UITableViewCell {

    @IBOutlet var brandLogo: UIImageView!
    @IBOutlet var brandDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
