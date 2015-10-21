//
//  User.swift
//  SocialEase
//
//  Created by Yuichi Kuroda on 10/18/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit
import Parse

private var _currentUser: User?
private let CURRENT_USER_KEY = "CURRENT_USER_KEY"

class User : NSObject {
    //    static var sampleDictionary = [
    //        [ "firstName": "Yuichi", "lastName": "Kuroda", "imageBinName": "yuichi-user-profile", "imageUrlPath": "" ],
    //        [ "firstName": "Amay", "lastName": "Singhal", "imageBinName": "amay-user-profile", "imageUrlPath": "" ],
    //        [ "firstName": "Uday", "lastName": "Mitra", "imageBinName": "uday-user-profile", "imageUrlPath": "" ],
    //        [ "firstName": "Yuichi", "lastName": "Kuroda", "imageBinName": "yuichi-user-profile", "imageUrlPath": "" ],
    //        [ "firstName": "Amay", "lastName": "Singhal", "imageBinName": "amay-user-profile", "imageUrlPath": "" ],
    //        [ "firstName": "Uday", "lastName": "Mitra", "imageBinName": "uday-user-profile", "imageUrlPath": "" ],
    //        [ "firstName": "Yuichi", "lastName": "Kuroda", "imageBinName": "yuichi-user-profile", "imageUrlPath": "" ],
    //        [ "firstName": "Amay", "lastName": "Singhal", "imageBinName": "amay-user-profile", "imageUrlPath": "" ],
    //        [ "firstName": "Uday", "lastName": "Mitra", "imageBinName": "uday-user-profile", "imageUrlPath": "" ],
    //        [ "firstName": "Yuichi", "lastName": "Kuroda", "imageBinName": "yuichi-user-profile", "imageUrlPath": "" ],
    //        [ "firstName": "Amay", "lastName": "Singhal", "imageBinName": "amay-user-profile", "imageUrlPath": "" ],
    //        [ "firstName": "Uday", "lastName": "Mitra", "imageBinName": "uday-user-profile", "imageUrlPath": "" ],
    //        [ "firstName": "Yuichi", "lastName": "Kuroda", "imageBinName": "yuichi-user-profile", "imageUrlPath": "" ],
    //        [ "firstName": "Amay", "lastName": "Singhal", "imageBinName": "amay-user-profile", "imageUrlPath": "" ],
    //        [ "firstName": "Uday", "lastName": "Mitra", "imageBinName": "uday-user-profile", "imageUrlPath": "" ],
    //    ]
    
    var name: String?
    var phoneNumber: String?
    var profileImageUrl: NSURL?
    var profileImageBinName: String?
    var userPreferences: UserPreferences? {
        didSet {
            pfUser!["userPreferences"] = userPreferences?.encodedString()
            pfUser!.saveInBackground()
        }
    }
    
    func getEmailAddress() -> String {
        return "\(phoneNumber!)@socialease.com"
    }
    
    func getDummyPassword() -> String {
        return phoneNumber!
    }
    
    private(set) var pfUser: PFUser?
    
    init(pfUser: PFUser) {
        self.name = pfUser["name"] as? String
        self.phoneNumber = pfUser["phone"] as? String
        if let encodedPreferencesString = pfUser["userPreferences"] as? String {
            self.userPreferences = UserPreferences.getUserPreferences(encodedPreferencesString)
        }
        self.pfUser = pfUser
    }
    
    override init() {
    }
    
    class var currentUser: User? {
        get {
        if _currentUser == nil {
        // read last logged in user from PFUser
        let pfUser = PFUser.currentUser()
        if pfUser != nil {
        _currentUser = User(pfUser: pfUser!)
        }
        }
        return _currentUser
        }
        
        set(user) {
            _currentUser = user
        }
    }
    
    func signUpInBackground(completion: (user: User?, error: NSError?) -> ()) {
        let pfUser = PFUser()
        pfUser.email = getEmailAddress()
        pfUser.password = phoneNumber
        pfUser.username = phoneNumber
        pfUser["phone"] = phoneNumber
        pfUser["name"] = name
        
        pfUser.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                completion(user: nil, error: error)
            } else {
                let user = User(pfUser: pfUser)
                completion(user: user, error: nil)
            }
        }
    }
    
    class func logInInBackground(phoneNumber: String, completion: (user: User?, error: NSError?) -> ()) {
        PFUser.logInWithUsernameInBackground(phoneNumber, password: phoneNumber) { (pfUser, error) -> Void in
            if pfUser != nil {
                let user = User(pfUser: pfUser!)
                completion(user: user, error: nil)
            } else {
                completion(user: nil, error: error)
            }
        }
    }
    
    
    class func friendsForCurrentUser(completion: (friends: [User]?, error: NSError?) -> Void) {
        // TODO: Retrieve all friends for current logged in user.
        
        var friends = [User]()
        
        /* TODO: Write init()
        for friendDictionary in sampleDictionary {
            let friend = User(dictionary: friendDictionary)
            friends.append(friend)
        }*/
        
        completion(friends: friends, error: nil)
    }
    
}