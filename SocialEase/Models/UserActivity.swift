//
//  UserActivity.swift
//  SocialEase
//
//  Created by Amay Singhal on 10/26/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit
import Parse

class UserActivity: NSObject {
    // MARK: - Properties
    static let ObjectName = "UserActivity"
    struct Fields {
        static let OjbectId = "objectId"
        static let UserId = "userId"
        static let PlanId = "planId"
        static let ActivityId = "activityId"
        static let Activity = "activity"
        static let Vote = "vote"
    }

    // MARK: Stored
    private var object: PFObject

    // MARK: Computed
    var id: String? {
        return object.objectId
    }

    var pfObject: PFObject {
        return object
    }

    var userId: String? {
        return object[Fields.UserId] as? String
    }

    var activityId: String? {
        return object[Fields.ActivityId] as? String
    }

    private var _activity: Activity?
    var activity: Activity? {
        if _activity == nil {
            if let activityObject = object[Fields.Activity] as? PFObject {
                _activity = Activity(activityObject: activityObject)
            }
        }
        return _activity
    }

    var vote: UserActivityVote {
        get {
            let userVote = UserActivityVote.None.rawValue
            return UserActivityVote(rawValue: object[Fields.Vote] as? Int ?? userVote) ?? UserActivityVote.None
        }
        set(newValue) {
            object[Fields.Vote] = newValue.rawValue
        }
    }

    // MARK: - Initializers
    init(userActivityObject: PFObject) {
        object = userActivityObject
    }

    convenience init(userId: String, planId: String, activity: Activity) {
        let pfObject = PFObject(className: UserActivity.ObjectName)
        pfObject[Fields.UserId] = userId
        pfObject[Fields.PlanId] = planId
        pfObject[Fields.ActivityId] = activity.id
        pfObject[Fields.Activity] = activity.pfObject
        pfObject[Fields.Vote] = UserActivityVote.None.rawValue
        self.init(userActivityObject: pfObject)
    }

    // MARK: - Class method
    class func saveObjectsInBackground(userActivities: [UserActivity]?, withCompletion completion: ((Bool, NSError?) -> Void)?) {

        if let userActivities = userActivities {
            // save parse objects
            PFObject.saveAllInBackground(userActivities.map { $0.pfObject } ) { (success: Bool, error: NSError?) -> Void in
                if let _ = error {
                    print(error?.localizedDescription)
                }
            }

        }
    }

    // MARK: - Class method
    class func fetchActivitiesForUser(user: PFUser, inPlan plan: Plan, withCompletion completion: (([UserActivity]?, NSError?) -> Void)) {

        // predicate
        let predicate = NSPredicate(format: "\(Fields.UserId) = '\(user.objectId!)' AND \(Fields.PlanId) = '\(plan.id!)'")

        // prepare query
        let userActivityQuery = PFQuery(className: ObjectName, predicate: predicate)
        userActivityQuery.cachePolicy = .NetworkElseCache // @todo: uncomment the line when all the fields have been finalized
        userActivityQuery.includeKey(Fields.Activity)

        userActivityQuery.findObjectsInBackgroundWithBlock { (pfObjects: [PFObject]?, error: NSError?) -> Void in
            var usrActivities: [UserActivity]?
            if let pfObjects = pfObjects {
                usrActivities = pfObjects.map { UserActivity(userActivityObject: $0) }
            } else {
                print(error?.localizedDescription)
            }
            completion(usrActivities, error)
        }
    }

}
