//
//  Plan.swift
//  SocialEase
//
//  Created by Amay Singhal on 10/24/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit
import Parse

class Plan: NSObject {

    // MARK: - Properties
    static let ObjectName = "Plan"
    struct Fields {
        static let Name = "name"
        static let OccurrenceDate = "occurrenceDate"
        static let Image = "image"
        static let Comment = "comment"
        static let ActivityObjectIdList = "activityObjectIdList"
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

    var name: String? {
        return object[Fields.Name] as? String
    }

    var occuranceDateTime: NSDate? {
        return object[Fields.OccurrenceDate] as? NSDate
    }

    var comment: String? {
        return object[Fields.Comment] as? String
    }

    var activityIds: [String]? {
        return object[Fields.ActivityObjectIdList] as? [String]
    }

    var currentUserStatus: UserPlanStatus?

    private var users: [User]?
    private var planOrganizer: User?

    // MARK: - Initializers
    init(planObject: PFObject) {
        object = planObject
    }

    // MARK: - Methods
    func setImageOnUIImageView(view: UIImageView) {
        if let imageFile = object[Fields.Image] as? PFFile {
            imageFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if let imageData = imageData {
                    view.image = UIImage(data: imageData)
                    view.contentMode = UIViewContentMode.ScaleToFill;
                }
            }
        }
    }

    func getPlanUsersWithCompletion(completion: (([User]?, NSError?) -> ())) {
        if let users = users {
            completion(users, nil)
        } else {
            UserPlans.getUsersForPlan(self, usingCache: false) { (users: [User]?, error: NSError?) -> () in
                self.users = users
                completion(users, error)
            }
        }
    }

    func getPlanOganizerWithCompletion(completion: ((User?, NSError?) -> ())) {
        if let planOrganizer = planOrganizer {
            completion(planOrganizer, nil)
        } else {
            UserPlans.getOrganizerForPlan(self, usingCache: false) { (user: User?, error: NSError?) -> () in
                self.planOrganizer = user
                completion(user, error)
            }
        }
    }


    // MARK: - Class methods
    class func fetchPlanId(id: String, withCompletion completion: ((PFObject?, NSError?) -> ())?) {
        let query = PFQuery(className: ObjectName)
        query.getObjectInBackgroundWithId(id) { (planObject: PFObject?, error: NSError?) -> Void in
            completion?(planObject, error)
        }
    }
}
