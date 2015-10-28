//
//  UserPlans.swift
//  SocialEase
//
//  Created by Amay Singhal on 10/24/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit
import Parse


enum UserPlanStatus: Int {
    case Active = 1, Pending
}


class UserPlans: NSObject {
    static let ObjectName = "UserPlans"

    // fields names
    static let UserId = "userId"
    static let PlanId = "planId"
    static let PlanObject = "plan"
    static let UserObject = "user"
    static let PlanStatus = "planStatus"
    static let IsOrganizer = "isOrganizer"

    class func getUserPlanForStatus(status: UserPlanStatus, usingCache cache: Bool, withCompletion completion: (([Plan]?, NSError?) -> ())) {
        if let currentUser = PFUser.currentUser() {
            let predicate = NSPredicate(format: "\(UserId) = '\(currentUser.objectId!)' AND \(PlanStatus) = \(status.rawValue)")

            // prepare query
            let userPlanQuery = PFQuery(className: ObjectName, predicate: predicate)
            userPlanQuery.cachePolicy = cache ? .CacheElseNetwork : .NetworkElseCache
            userPlanQuery.includeKey(PlanObject) // really important; required to fetch pointer object

            userPlanQuery.findObjectsInBackgroundWithBlock { (userPlans: [PFObject]?, error: NSError?) -> Void in
                var userPlanWithStatus: [Plan]?
                if let userPlans = userPlans {
                    for plan in userPlans {
                        print(plan)
                    }
                    userPlanWithStatus = userPlans.map { (userPlanObject) -> Plan in
                        let plan = Plan(planObject: userPlanObject.objectForKey(PlanObject) as! PFObject)
                        plan.currentUserStatus = status
                        return plan
                    }
                }

                completion(userPlanWithStatus , error)
            }
        } else {
            print("Oops! No active user found")
        }
    }

    class func getUsersForPlan(plan: Plan, usingCache cache: Bool, withCompletion completion: (([User]?, NSError?) -> ())) {

        let predicate = NSPredicate(format: "\(PlanId) = '\(plan.id!)'")

        // prepare query
        let userPlanQuery = PFQuery(className: ObjectName, predicate: predicate)
        userPlanQuery.cachePolicy = cache ? .CacheElseNetwork : .NetworkElseCache
        userPlanQuery.includeKey(UserObject) // really important; required to fetch pointer object

        userPlanQuery.findObjectsInBackgroundWithBlock { (userPlans: [PFObject]?, error: NSError?) -> Void in
            var planUsers = [User]()
            if let userPlans = userPlans {
                for plan in userPlans {
                    if let pfuser = plan.objectForKey(UserObject) as? PFUser {
                        planUsers.append(User(pfUser: pfuser))
                    }
                }
            }

            completion(planUsers , error)
        }
    }

    class func getOrganizerForPlan(plan: Plan, usingCache cache: Bool, withCompletion completion: ((User?, NSError?) -> ())) {

        let predicate = NSPredicate(format: "\(PlanId) = '\(plan.id!)' AND \(IsOrganizer) = 1")

        // prepare query
        let userPlanQuery = PFQuery(className: ObjectName, predicate: predicate)
        userPlanQuery.cachePolicy = cache ? .CacheElseNetwork : .NetworkElseCache
        userPlanQuery.includeKey(UserObject) // really important; required to fetch pointer object

        userPlanQuery.findObjectsInBackgroundWithBlock { (userPlans: [PFObject]?, error: NSError?) -> Void in
            var planOrganizer: User?
            if let userPlans = userPlans {
                for plan in userPlans {
                    if let pfuser = plan.objectForKey(UserObject) as? PFUser {
                        planOrganizer = User(pfUser: pfuser)
                        break
                    }
                }
            }

            completion(planOrganizer , error)
        }
    }

    class func updateUserPlanStatusForPlan(plan: Plan, withStatus status: UserPlanStatus, withCompletion completion: ((Bool, NSError?) -> ())?) {
        if let currentUser = PFUser.currentUser() {
            let predicate = NSPredicate(format: "\(PlanId) = '\(plan.id!)' AND \(UserId) = '\(currentUser.objectId!)'")

            // prepare query
            let userPlanQuery = PFQuery(className: ObjectName, predicate: predicate)
            userPlanQuery.getFirstObjectInBackgroundWithBlock { (userPlanObject: PFObject?, error: NSError?) -> Void in
                if let userPlanObject = userPlanObject {
                    userPlanObject[PlanStatus] = status.rawValue
                    userPlanObject.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                        completion?(success, error)
                    })
                }
            }
        } else {
            print("Oops! No active user found")
        }
    }

    class func saveUserPlan(planObject: PFObject, withCompletion completion: (() -> ())?) {

        if let currentUser = PFUser.currentUser() {
            let userPlan = PFObject(className: ObjectName)

            userPlan[UserId] = currentUser.objectId
            userPlan[PlanObject] = planObject

            // save object
            userPlan.saveInBackgroundWithBlock{ (success: Bool, error: NSError?) -> Void in
                if success {
                    print("userPlan saved successfully")
                } else {
                    print(error?.localizedDescription)
                }
            }
        } else {
            print("Oops! No active user found")
        }
    }
}
