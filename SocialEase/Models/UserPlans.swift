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

    // MARK: - Properties

    // MARK: Parse object name
    static let ObjectName = "UserPlans"

    // MARK: Parse object fields
    static let UserId = "userId"
    static let PlanId = "planId"
    static let PlanObject = "plan"
    static let UserObject = "user"
    static let PlanStatus = "planStatus"
    static let IsOrganizer = "isOrganizer"

    private var pfObject: PFObject

    var plan: Plan? {
        if let planObject = pfObject[UserPlans.PlanObject] as? PFObject {
            let _plan = Plan(planObject: planObject)
            _plan.currentUserStatus = planStatus
            return _plan
        }
        return nil
    }

    var planStatus: UserPlanStatus {

        var planStatusId = UserPlanStatus.Pending.rawValue
        if let statusId = pfObject[UserPlans.PlanStatus] as? Int {
            planStatusId = statusId
        }
        return UserPlanStatus(rawValue: planStatusId) ?? UserPlanStatus.Pending
    }

    // MARK: - Instance methods
    init(userPlanObject: PFObject) {
        pfObject = userPlanObject
    }

    func getPfObject() -> PFObject {
        return pfObject
    }

    // MARK: - Class methods
    class func fetchCurrentUserPlanForPlanId(planId: String, usingCache cache: Bool, withCompletion completion: ((Plan?, NSError?) -> ())) {
        if let currentUser = PFUser.currentUser() {
            let predicate = NSPredicate(format: "\(UserId) = '\(currentUser.objectId!)' AND \(PlanId) = '\(planId)'")

            // prepare query
            let userPlanQuery = PFQuery(className: ObjectName, predicate: predicate)
            userPlanQuery.cachePolicy = cache ? .CacheElseNetwork : .NetworkElseCache
            userPlanQuery.includeKey(PlanObject) // really important; required to fetch pointer object

            userPlanQuery.getFirstObjectInBackgroundWithBlock { (userPlanObject: PFObject?, error: NSError?) -> Void in
                var plan: Plan?
                if let userPlanObject = userPlanObject {
                    let userPlan = UserPlans(userPlanObject: userPlanObject)
                    plan = userPlan.plan
                } else {
                    print(error?.localizedDescription)
                }
                completion(plan, error)
            }
        } else {
            print("Oops! No active user found")
        }
    }

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

        let predicate = NSPredicate(format: "\(PlanId) = '\(plan.id!)' AND \(IsOrganizer) = TRUE")

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
            } else {
                print(error?.localizedDescription)
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
