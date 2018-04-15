//
//  SubmitButton.swift
//  Ambasity V1
//
//  Created by Zak on 2/18/18.
//  Copyright © 2018 ClosestPath. All rights reserved.
//

import UIKit

@IBDesignable class SubmitButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    

}
