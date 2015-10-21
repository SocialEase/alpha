//
//  Group.swift
//  SocialEase
//
//  Created by Yuichi Kuroda on 10/18/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

class Group: NSObject {
    static var sampleDictionary = [
        [ "groupId" : "AAA", "name" : "Codepath", ],
        [ "groupId" : "BBB", "name" : "SF", ],
        [ "groupId" : "CCC", "name" : "Clubbing", ],
    ]
    
    var groupId = ""
    var name = ""
    var users = [User]()
    
    init(dictionary: [String:String]) {
        if let value = dictionary["groupId"] as String? {
            self.groupId = value
        }
        if let value = dictionary["name"] as String? {
            self.name = value
        }
        
        // TODO: Delete once user list is retrieved dynamically
        //if let value = dictionary["users"] as [String]? {
        for i in 1...15 {
            users.append(User())
        }
    }
    
    class func groups(array: [ [String:String] ]) -> [Group] {
        var groups = [Group]()
        for dictionary in array {
            let group = Group(dictionary: dictionary)
            groups.append(group)
        }
        return groups
    }
    
    class func groupsForCurrentUser(completion: (groups: [Group]?, error: NSError?) -> Void) {
        // TODO: Retrieve all groups for current logged in user.
        
        var groups = [Group]()
        
        for groupDictionary in sampleDictionary {
            let group = Group(dictionary: groupDictionary)
            groups.append(group)
        }
        
        completion(groups: groups, error: nil)
    }
}
