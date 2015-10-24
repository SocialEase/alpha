//
//  Plan.swift
//  SocialEase
//
//  Created by Amay Singhal on 10/24/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit
import Parse

enum PlanStatus: Int {
    case Active = 1, Pending
}

class Plan: NSObject {

    // MARK: - Properties
    static let ObjectName = "Plan"
    struct Fields {
        static let PlanStatus = "planStatus"
        static let Name = "name"
    }

    // MARK: Stored
    private var object: PFObject

    // MARK: Computed
    var id: String? {
        return object.objectId
    }

    var name: String? {
        return object[Fields.Name] as? String
    }

    var status: Int? {
        return object[Fields.PlanStatus] as? Int
    }

    // MARK: - Initializers
    init(planObject: PFObject) {
        object = planObject
    }

    // MARK: - Class methods
    class func fetchPlanId(id: String, withCompletion completion: ((PFObject?, NSError?) -> ())?) {
        let query = PFQuery(className: ObjectName)
        query.getObjectInBackgroundWithId(id) { (planObject: PFObject?, error: NSError?) -> Void in
            completion?(planObject, error)
        }
    }
}
