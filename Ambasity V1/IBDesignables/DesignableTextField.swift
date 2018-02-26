//
//  DesignableTextField.swift
//  Ambasity V1
//
//  Created by Zak on 2/18/18.
//  Copyright © 2018 ClosestPath. All rights reserved.
//

import UIKit

@IBDesignable class DesignableTextField: UITextField {

    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }

}
