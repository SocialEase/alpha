//
//  User.swift
//  SocialEase
//
//  Created by Yuichi Kuroda on 10/18/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit
import Parse
import Contacts

private var _currentUser: User?

struct ParseUser {
    static let ObjectName = "User"

    // object fields
    static let Id = "objectId"
}


class User : NSObject {

    var id: String?
    var name: String?
    var lastName: String?
    var phoneNumber: String?
    var profileImageUrl: NSURL?
    var profileImageBinName: String?
    var groups: String?
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
        self.id = pfUser.objectId
        self.name = pfUser["name"] as? String
        self.lastName = pfUser["lastName"] as? String
        self.phoneNumber = pfUser["phone"] as? String
        if let encodedPreferencesString = pfUser["userPreferences"] as? String {
            self.userPreferences = UserPreferences.getUserPreferences(encodedPreferencesString)
        }
        self.pfUser = pfUser
        if let profileImageBinName = pfUser["profileImageBinName"] as? String {
            self.profileImageBinName = profileImageBinName
        }
        if let profileImageUrlString = pfUser["profileImageUrl"] as? String {
            self.profileImageUrl = NSURL(string: profileImageUrlString)
        }
        if let groups = pfUser["groups"] as? String {
            self.groups = groups
        }
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

    // Description: Retrieves a list of account users that have not been added as account friends yet, but exist in the address book.
    class func searchContactsNotBefriendedYet(accountFriends: [User], completion: (response: [PFObject]?, error: NSError?) -> Void) {
        CNContactStore().requestAccessForEntityType(.Contacts) { (success, errorOrNil) -> Void in
            guard success else {
                return
            }
            
            let fetchRequest = CNContactFetchRequest(keysToFetch: [CNContactPhoneNumbersKey])
            var numbers = [String]()
            try! CNContactStore().enumerateContactsWithFetchRequest(fetchRequest) { (contact, stopPointer) -> Void in
                for number in contact.phoneNumbers {
                    if let number = number.value as? CNPhoneNumber {
                        var numberString = number.stringValue
                        var alreadyBefriended = false
                        
                        numberString = numberString.stringByReplacingOccurrencesOfString("(", withString: "")
                        numberString = numberString.stringByReplacingOccurrencesOfString(")", withString: "")
                        numberString = numberString.stringByReplacingOccurrencesOfString(" ", withString: "")
                        numberString = numberString.stringByReplacingOccurrencesOfString("-", withString: "")
                        
                        //print("Found phone number: \(numberString)")
                        
                        for accountFriend in accountFriends {
                            if accountFriend.phoneNumber == numberString {
                                alreadyBefriended = true
                                break
                            }
                        }
                        
                        // If this friend in Contacts is not a account friend yet, then add number.
                        if !alreadyBefriended {
                            numbers.append(numberString)
                        }
                    }
                }
            }
            
            if numbers.count > 0 {
                // Based on all numbers found in Contacts (that we haven't befriended yet), search those numbers that own an account.
                let queryUsersWhoHaveAccounts = PFQuery(className: "_User")
                queryUsersWhoHaveAccounts.whereKey("phone", containedIn: numbers)
                queryUsersWhoHaveAccounts.findObjectsInBackgroundWithBlock() { (pfObjects: [PFObject]?, error: NSError?) -> Void in
                    completion(response: pfObjects, error: error)
                }
            } else {
                completion(response: nil, error: nil)
            }

        }
    }
    
    class func friendsForUser(userId: String, completion: (friends: [User]?, error: NSError?) -> Void) {
        var friends = [User]()
        
        // Retrieve all friends for current logged in user.
        PFCloud.callFunctionInBackground("user__get_user_friends", withParameters: ["userid":userId]) { (response: AnyObject?, error: NSError?) -> Void in
            
            if let results = response as? NSArray {
                for result in results {
                    friends.append(User(pfUser: result as! PFUser))
                }
            }
            
            // Get friends from address book (who aren't account friends yet but also have accounts) and add them to friends list
            searchContactsNotBefriendedYet(friends) { (response: [PFObject]?, error: NSError?) -> Void in
                
                if let pfObjects = response {
                    for pfObject in pfObjects {
                        friends.append(User(pfUser: pfObject as! PFUser))
                    }
                }
                
                completion(friends: friends, error: error)
            }
        }
        
    }
    
}
