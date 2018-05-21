//
//  Models.swift
//  Ambasity V1
//
//  Created by Zak on 5/15/18.
//  Copyright © 2018 ClosestPath. All rights reserved.
//

import UIKit
import Parse

struct Brand {
    
    var objectId: String
    var name: String
    var description: String?
    var logo: PFFile?
    var link: String?
    
}

struct Form {
    
    var headerText: String
    var descriptionText: String
    
}

struct OnboardingPage {
    
    let imageName: String
    let headerText: String
    let bodyText: String
    let pageNumber: Int
    
}

enum Setting {
    
    case Username, Email, PhoneNumber, Bio, Message, ProfileImageFile, Venmo, PayPal
    
}

protocol SettingDelegate {
    
    func settingValueSelected(setting: Setting, value: String)
    
}

struct User {
    
    var username: String
    var email: String
    var phoneNumber: String?
    var bio: String?
    var message: String?
    var profileImageFile: PFFile?
    var venmoId: String?
    var paypalUsername: String?
    
    mutating func getUserData() {
        guard let currentUser = PFUser.current() else { return }
        
        username = currentUser.username!
        email = currentUser.email!
        phoneNumber = currentUser["phoneNumber"] as? String
        bio = currentUser["bio"] as? String
        message = currentUser["personalizedMessage"] as? String
        profileImageFile = currentUser["profileImage"] as? PFFile
        venmoId = currentUser["venmoId"] as? String
        paypalUsername = currentUser["paypalUsername"] as? String
    }
}
