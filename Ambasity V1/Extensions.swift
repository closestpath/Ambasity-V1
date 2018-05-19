//
//  Extensions.swift
//  Ambasity V1
//
//  Created by Zak on 5/14/18.
//  Copyright © 2018 ClosestPath. All rights reserved.
//

import UIKit
import Parse

extension UIColor {
    static var mainBlue = UIColor(red: 60/255, green: 190/255, blue: 1, alpha: 1)
}

extension UINavigationBar {
    
    func transparentNavigationBar() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
    }
    
    func opaqueNavigationBar() {
        self.setBackgroundImage(nil, for: .default)
        self.shadowImage = nil
    }
    
}

extension UIViewController {
    
    @objc func displayAlert (title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

extension UIView {
    
    func startActivityIndicator(overlay: UIView, activityIndicator: UIActivityIndicatorView) {
        overlay.backgroundColor = .clear
        
        activityIndicator.center = center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        [overlay, activityIndicator].forEach { (view) in
            addSubview(view)
        }
        
        overlay.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        UIView.animate(withDuration: 0.5) {
            overlay.backgroundColor = UIColor.init(white: 1, alpha: 0.6)
        }
        
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stopActivityIndicator(overlay: UIView, activityIndicator: UIActivityIndicatorView) {
        overlay.removeFromSuperview()
        activityIndicator.stopAnimating()
        
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
    }
    
    func setRelativeSize(width: NSLayoutDimension?, height: NSLayoutDimension?, widthMultiplier: CGFloat = 1, heightMultiplier: CGFloat = 1) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let width = width {
            widthAnchor.constraint(equalTo: width, multiplier: widthMultiplier).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalTo: height, multiplier: heightMultiplier).isActive = true
        }
    }
    
    func setFixedSize(size: CGSize = .zero) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
        
    }
}
