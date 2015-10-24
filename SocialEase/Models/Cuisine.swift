//
//  Cuisine.swift
//  SocialEase
//
//  Created by Soumya on 10/18/15.
//  Copyright © 2015 udaymitra. All rights reserved.
//

import UIKit
import Parse

class Cuisine: NSObject {
    var cuisineName: String!
    var imageUrl: NSURL!
    var userSelected: Bool = false

    init(pfObject: PFObject) {
        cuisineName = pfObject["cuisineName"]! as! String
        let imageUrlString = pfObject["imageUrl"]! as! String
        imageUrl = NSURL(string: imageUrlString)
    }

    // get all cuisines from parse
    class func getCuisines(completion: ([Cuisine]?, NSError?) -> ()) {
        let query = PFQuery(className: "Cuisine")
        query.findObjectsInBackgroundWithBlock { (pfObjects, error) -> Void in
            if (error != nil) {
                completion(nil, error)
            } else {
                var cuisines = [Cuisine]()
                for pfObject in pfObjects! {
                    cuisines.append(Cuisine(pfObject: pfObject))
                }
                completion(cuisines, nil)
            }
        }
    }
}
