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
    static let PlanObject = "plan"


    class func getUserPlanForStatus(status: UserPlanStatus, usingCache cache: Bool, withCompletion completion: (([Plan]?, NSError?) -> ())) {
        if let currentUser = PFUser.currentUser() {
            let predicate = NSPredicate(format: "userId = '\(currentUser.objectId!)' AND planStatus = \(status.rawValue)")

            print(predicate)
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
                    userPlanWithStatus = userPlans.map { Plan(planObject: $0.objectForKey(PlanObject) as! PFObject) }
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
