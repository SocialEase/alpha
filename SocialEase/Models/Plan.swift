//
//  Plan.swift
//  SocialEase
//
//  Created by Amay Singhal on 10/24/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit
import Parse

enum PlanType: Int {
    case Brunch = 1, Lunch, Dinner, Coffee, HappyHour

    func getTypeString() -> String {
        switch self {
        case .Brunch:
            return "Brunch"
        case .Lunch:
            return "Lunch"
        case .Dinner:
            return "Dinner"
        case .Coffee:
            return "Coffee"
        case .HappyHour:
            return "Happy Hour"
        }
    }
}

class Plan: NSObject {

    // MARK: - Properties
    static let ObjectName = "Plan"
    struct Fields {
        static let Name = "name"
        static let OccurrenceDate = "occurrenceDate"
        static let Image = "image"
        static let ImageUrl = "imageUrl"
        static let Comment = "comment"
        static let GroupObjectId = "groupObjectId"
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

    var imageUrl: NSURL? {
        if let url = object[Fields.ImageUrl] as? String {
            return NSURL(string: url)
        }
        return nil
    }

    var currentUserStatus: UserPlanStatus?

    var users: [User]?
    private var planOrganizer: User?

    // MARK: - Initializers
    init(planObject: PFObject) {
        object = planObject
    }

    convenience init(planObject: PFObject, status: UserPlanStatus, organizer: User, planUsers: [User]?) {
        self.init(planObject: planObject)
        currentUserStatus = .Active
        users = planUsers
        planOrganizer = organizer
    }

    // MARK: - Methods
    func setImageOnUIImageView(view: UIImageView) {
        if let imageUrl = imageUrl {
            view.contentMode = .ScaleAspectFill
            view.clipsToBounds = true
            view.setImageWithURL(imageUrl)
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

    class func createPlanWithName(name: String, atOccuranceTime time: NSDate, forGroup group: UserGroup, withActivities activities: [Activity], withCompletion completion: ((Plan?, NSError?) -> ())) {
        let planObject = PFObject(className: ObjectName)
        planObject[Fields.Name] = name
        planObject[Fields.OccurrenceDate] = time
        planObject[Fields.GroupObjectId] = group.groupId!
        planObject[Fields.ActivityObjectIdList] = activities.map { $0.id! }

        if let url = activities.first?.posterImageUrl?.absoluteString {
            planObject[Fields.ImageUrl] = url
        }

        planObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success {
                completion(Plan(planObject: planObject), error)
            } else {
                print(error?.localizedDescription)
                completion(nil, error)
            }
        }
    }
}
