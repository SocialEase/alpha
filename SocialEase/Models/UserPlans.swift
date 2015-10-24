//
//  UserPlans.swift
//  SocialEase
//
//  Created by Amay Singhal on 10/24/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit
import Parse


class UserPlans: NSObject {
    static let ObjectName = "UserPlans"

    // fields names
    static let UserId = "userId"
    static let PlanObject = "plan"


    class func getUserPlanForStatus(status: PlanStatus, usingCache cache: Bool, withCompletion completion: (([Plan]?, NSError?) -> ())) {
        if let currentUser = PFUser.currentUser() {
            let predicate = NSPredicate(format: "userId = '\(currentUser.objectId!)'")

            // prepare query
            let userPlanQuery = PFQuery(className: ObjectName, predicate: predicate)
            userPlanQuery.cachePolicy = cache ? .CacheElseNetwork : .NetworkElseCache
            userPlanQuery.includeKey(PlanObject) // really important; required to fetch pointer object

            userPlanQuery.findObjectsInBackgroundWithBlock { (userPlans: [PFObject]?, error: NSError?) -> Void in
                var userPlanWithStatus = [Plan]()
                if let userPlans = userPlans {
                    for userPlan in userPlans {
                        if let planPFObject = userPlan.objectForKey(PlanObject) as? PFObject {
                            let plan = Plan(planObject: planPFObject)
                            plan.status! == status.rawValue ? userPlanWithStatus.append(plan) : ()
                        }
                    }
                }

                completion(userPlanWithStatus , error)
            }
        } else {
            print("Oops! No active user found")
        }
    }

    class func saveUserPlan(planObject: PFObject, withCompletion completion: (() -> ())?) {

        if let currentUser = PFUser.currentUser() {
            let userPlan = PFObject(className: ObjectName)
            print(currentUser)
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
