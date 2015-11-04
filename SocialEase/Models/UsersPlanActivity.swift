//
//  UsersPlanActivity.swift
//  SocialEase
//
//  Created by Amay Singhal on 10/29/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit
import Parse

class UsersPlanActivity: NSObject {

    class func createPlanAndActivitiesForGroup(group: UserGroup, withPlan plan: Plan, andActivities activities: [Activity], byOrganizer organizer: PFUser, withCompletion completion: ((Bool, NSError?) -> ())) {

        // append organizers to plan users list
        var planUsers = group.pfUsers
        planUsers.append(organizer)

        // create user plans for each users
        var userPlanActivityObjects = [PFObject]()
        for user in planUsers {
            let userPlan = PFObject(className: UserPlans.ObjectName)
            userPlan[UserPlans.UserId] = user.objectId!
            userPlan[UserPlans.IsOrganizer] = user.objectId! == organizer.objectId! ? true : false
            userPlan[UserPlans.PlanId] = plan.id!
            userPlan[UserPlans.PlanStatus] = user.objectId! == organizer.objectId! ? UserPlanStatus.Active.rawValue : UserPlanStatus.Pending.rawValue
            userPlan[UserPlans.PlanObject] = plan.pfObject
            userPlan[UserPlans.UserObject] = user

            userPlanActivityObjects.append(userPlan)
        }

        // create user activities for organizer only
        for activity in activities {
            let userActivityObject = PFObject(className: UserActivity.ObjectName)
            userActivityObject[UserActivity.Fields.UserId] = organizer.objectId!
            userActivityObject[UserActivity.Fields.PlanId] = plan.id!
            userActivityObject[UserActivity.Fields.ActivityId] = activity.id!
            userActivityObject[UserActivity.Fields.Activity] = activity.pfObject
            userActivityObject[UserActivity.Fields.Vote] = UserActivityVote.Like.rawValue

            userPlanActivityObjects.append(userActivityObject)
        }

        // save parse objects
        PFObject.saveAllInBackground(userPlanActivityObjects) { (success: Bool, error: NSError?) -> Void in
            completion(success, error)
        }
    }

    class func updateAndFetchVotingStatusForPlan(plan: Plan, withCompletion completion: ((NSDictionary?, NSError?) -> ())?) {

        PFCloud.callFunctionInBackground("plan__update_voting_status", withParameters: ["planId": plan.id!]) { (response: AnyObject?, error: NSError?) -> Void in
            if let response = response as? NSDictionary {
                print(response)
                completion?(response, error)
            } else {
                completion?(nil, error)
            }
        }
    }
}
