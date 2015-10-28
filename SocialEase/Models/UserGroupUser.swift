//
//  UserGroupUser.swift
//  SocialEase
//
//  Created by Amay Singhal on 10/27/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit
import Parse

class UserGroupUser: NSObject {
    // MARK: - Properties
    static let ObjectName = "UserGroupUsers"
    struct Fields {
        static let OjbectId = "objectId"
        static let UserId = "userId"
        static let GroupId = "groupId"
        static let Group = "group"
        static let GroupUsers = "groupUsers"
    }

    class func fetchGroupAndGroupUsersForUser(user: PFUser, withCompletion completion: (([UserGroup]?, NSError?) -> ())) {
        let predicate = NSPredicate(format: "\(Fields.UserId) = '\(user.objectId!)'")

        let query = PFQuery(className: ObjectName, predicate: predicate)
        query.includeKey(Fields.Group)
        query.includeKey(Fields.GroupUsers)

        query.findObjectsInBackgroundWithBlock { (queryObjects: [PFObject]?, error: NSError?) -> Void in
            var userGroups: [UserGroup]
            if let queryObjects = queryObjects {
                userGroups = [UserGroup]()
                for object in queryObjects {
                    if let group = object[Fields.Group] as? PFObject, let userList = object[Fields.GroupUsers] as? [PFUser] {
                        print(group)
                        print(userList)
                        userGroups.append(UserGroup(groupObject: group, usersObject: userList))
                    }
                }
                completion(userGroups, error)
            } else {
                print(error?.localizedDescription)
                completion(nil, error)
            }
        }
    }
}
