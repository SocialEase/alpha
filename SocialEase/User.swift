//
//  User.swift
//  SocialEase
//
//  Created by Yuichi Kuroda on 10/18/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

class User {
    static var sampleDictionary = [
        [ "firstName": "Yuichi", "lastName": "Kuroda", "imageBinName": "yuichi-user-profile", "imageUrlPath": "" ],
        [ "firstName": "Amay", "lastName": "Singhal", "imageBinName": "amay-user-profile", "imageUrlPath": "" ],
        [ "firstName": "Uday", "lastName": "Mitra", "imageBinName": "uday-user-profile", "imageUrlPath": "" ],
        [ "firstName": "Yuichi", "lastName": "Kuroda", "imageBinName": "yuichi-user-profile", "imageUrlPath": "" ],
        [ "firstName": "Amay", "lastName": "Singhal", "imageBinName": "amay-user-profile", "imageUrlPath": "" ],
        [ "firstName": "Uday", "lastName": "Mitra", "imageBinName": "uday-user-profile", "imageUrlPath": "" ],
        [ "firstName": "Yuichi", "lastName": "Kuroda", "imageBinName": "yuichi-user-profile", "imageUrlPath": "" ],
        [ "firstName": "Amay", "lastName": "Singhal", "imageBinName": "amay-user-profile", "imageUrlPath": "" ],
        [ "firstName": "Uday", "lastName": "Mitra", "imageBinName": "uday-user-profile", "imageUrlPath": "" ],
        [ "firstName": "Yuichi", "lastName": "Kuroda", "imageBinName": "yuichi-user-profile", "imageUrlPath": "" ],
        [ "firstName": "Amay", "lastName": "Singhal", "imageBinName": "amay-user-profile", "imageUrlPath": "" ],
        [ "firstName": "Uday", "lastName": "Mitra", "imageBinName": "uday-user-profile", "imageUrlPath": "" ],
        [ "firstName": "Yuichi", "lastName": "Kuroda", "imageBinName": "yuichi-user-profile", "imageUrlPath": "" ],
        [ "firstName": "Amay", "lastName": "Singhal", "imageBinName": "amay-user-profile", "imageUrlPath": "" ],
        [ "firstName": "Uday", "lastName": "Mitra", "imageBinName": "uday-user-profile", "imageUrlPath": "" ],
    ]
    
    var firstName = ""
    var lastName = ""
    var imageBinName: String?
    var imageUrl: NSURL?
    
    // TODO: Delete once user list is retrieved dynamically
    init() {}
    
    init(dictionary: [String:String]) {
        if let value = dictionary["firstName"] as String? {
            self.firstName = value
        }
        if let value = dictionary["lastName"] as String? {
            self.lastName = value
        }
        if let value = dictionary["imageBinName"] as String? {
            self.imageBinName = value
        }
        if let value = dictionary["imageUrlPath"] as String? {
            if let url = NSURL(string: value) {
                self.imageUrl = url
            }
        }
        
    }
    
    class func friendsForCurrentUser(completion: (friends: [User]?, error: NSError?) -> Void) {
        // TODO: Retrieve all friends for current logged in user.
        
        var friends = [User]()
        
        for friendDictionary in sampleDictionary {
            let friend = User(dictionary: friendDictionary)
            friends.append(friend)
        }
        
        completion(friends: friends, error: nil)
    }
    
}
