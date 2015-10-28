//
//  UserGroup.swift
//  SocialEase
//
//  Created by Amay Singhal on 10/27/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit
import Parse

class UserGroup: NSObject {
    // MARK: - Properties
    static let ObjectName = "Group"
    struct Fields {
        static let OjbectId = "objectId"
        static let Name = "groupName"
    }

    var groupId: String? {
        return _groupObject[Fields.OjbectId] as? String
    }

    var name: String? {
        return _groupObject[Fields.Name] as? String
    }

    var users: [User]? {
        return _groupUsersObjects.map { User(pfUser: $0) }
    }

    var pfUsers: [PFUser] {
        return _groupUsersObjects
    }

    private var _groupObject: PFObject
    private var _groupUsersObjects: [PFUser]

    init(groupObject: PFObject, usersObject: [PFUser]) {
        _groupObject = groupObject
        _groupUsersObjects = usersObject
    }
}
