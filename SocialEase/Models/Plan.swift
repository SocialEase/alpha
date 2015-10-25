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

    var occuranceDateTime: NSDate? {
        return object[Fields.OccurrenceDate] as? NSDate
    }

    var comment: String? {
        return object[Fields.Comment] as? String
    }

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
                }
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