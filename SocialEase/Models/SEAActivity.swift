//
//  SEAActivity.swift
//  SocialEaseSuggestionsWorkflow
//
//  Created by Amay Singhal on 10/18/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit
import Parse

class SEAActivity: NSObject {

    var name: String?
    var location: String?
    var rating: Float?
    var posterImageUrl: NSURL?

    init(dictionary: NSDictionary) {
        super.init()

        name = dictionary["name"] as? String
        location = dictionary["location"] as? String
        rating = dictionary["rating"] as? Float
        if let imageUrl = dictionary["posterImage"] as? String {
            posterImageUrl = NSURL(string: imageUrl)
        }
    }

    class func getSuggestedActivitiesForGroupId(id: Int, withCompletion completion: (([SEAActivity]?, NSError?) -> ())?) {

        PFCloud.callFunctionInBackground("user_group__get_activity_recommendations", withParameters: ["groupId": id, "activityType": 2]) { (response: AnyObject?, error: NSError?) -> Void in
            if let response = response as? [NSDictionary] {
                completion?(response.map { SEAActivity(dictionary: $0) }, error)
            }
        }
    }
}
