//
//  Group.swift
//  SocialEase
//
//  Created by Yuichi Kuroda on 10/18/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit
import Parse

class Group: NSObject {

    var groupId: String?
    var name: String?
    var users = [User]()
    
    init(pfObject: PFObject) {
        super.init()
        
        self.groupId = pfObject["objectId"] as? String
        self.name = pfObject["groupName"] as? String
        if let usersString = pfObject["users"] as? String {
            let userObjectIds = usersString.characters.split{$0 == ","}.map(String.init)
            for userObjectId in userObjectIds {
                if let user = try? PFQuery.getUserObjectWithId(userObjectId) {
                    users.append(User(pfUser: user))
                }
                /* NOTE: The above synchronous call generates an ugly warning. The below block will do the same thing
                asynchronously, however, since each user is retrieved asynchronously, we don't know when the group is
                complete with all user information. A semaphore and callback can address this.
                let userQuery = PFQuery(className: "_User")
                userQuery.whereKey("objectId", equalTo: userObjectId)
                userQuery.findObjectsInBackgroundWithBlock({ (pfObjects: [PFObject]?, error: NSError?) -> Void in
                    if let pfObjects = pfObjects {
                        for pfObject in pfObjects {
                            if let pfUser = pfObject as? PFUser {
                                self.users.append(User(pfUser: pfUser))
                            }
                        }
                    }
                })*/
            }
        }
    }

    class func groupsForCurrentUser(completion: (groups: [Group]?, error: NSError?) -> Void) {
        var groups = [Group]()
        
        // Retrieve all groups for current logged in user.
        if let currentUser = User.currentUser {
            if let userId = currentUser.id {
                PFCloud.callFunctionInBackground("user__get_user_groups", withParameters: ["userid":userId]) { (response: AnyObject?, error: NSError?) -> Void in
                    
                    if let results = response as? NSArray {
                        for result in results {
                            groups.append(Group(pfObject: result as! PFObject))
                        }
                    }
                    
                    completion(groups: groups, error: error)
                }
            }
        }
    }
    
    class func createNewGroup(name: String, users: [User], completion: (error: NSError?) -> Void) {
        var pfUsers = [PFUser]()
        var usersString = ""
        
        for user in users {
            if let pfUser = user.pfUser {
                pfUsers.append(pfUser)
                if usersString != "" {
                    usersString += ","
                }
                usersString += user.id ?? ""
            }
        }
        
        // First, create a Group in the db, so a groupId is automatically generated
        let pfGroup = PFObject(className: "Group")
        pfGroup["users"] = usersString
        pfGroup["groupName"] = name
        pfGroup.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            
            if success && error == nil {
                
                if let newGroupObjectId = pfGroup.objectId {
            
                    // Next, push to the UserGroupUsers table where everything is linked
                    let pfUserGroupUsers = PFObject(className: "UserGroupUsers")
                    pfUserGroupUsers["groupId"] = newGroupObjectId
                    pfUserGroupUsers["groupUsers"] = pfUsers
                    pfUserGroupUsers["userId"] = User.currentUser?.id!
                    pfUserGroupUsers["group"] = pfGroup
                    pfUserGroupUsers.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                        completion(error: error)
                    }
                } else {
                    // TODO: Handle error
                }
            } else {
                // TODO: Handle error
            }
        }
    }
}
