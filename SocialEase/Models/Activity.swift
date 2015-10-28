//
//  Activity.swift
//  SocialEase
//
//  Created by Amay Singhal on 10/25/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit
import Parse
import MapKit
import CoreLocation

enum UserActivityVote: Int {
    case Dislike = -1
    case None = 0
    case Like = 1
}


class Activity: NSObject, MKAnnotation {

    // MARK: - Properties
    static let ObjectName = "Activity"
    struct Fields {
        static let OjbectId = "objectId"
        static let Name = "name"
        static let Description = "description"
        static let Image = "image"
        static let Location = "location"
        static let Rating = "rating"
        static let AddressLine1 = "addressLine1"
        static let City = "city"
        static let State = "state"
        static let Zipcode = "zipcode"
    }
    static let MapAnnotationIdentifier = "activityAnnotation"

    // MARK: Stored
    private var object: PFObject

    // MARK: Computed
    var id: String? {
        return object.objectId
    }

    var name: String? {
        return object[Fields.Name] as? String
    }

    var details: String? {
        return object[Fields.Description] as? String
    }

    var seaLocation: CLLocation? {
        if let loc = object[Fields.Location] as? PFGeoPoint {
            return CLLocation(latitude: loc.latitude, longitude: loc.longitude)
        }
        return nil
    }

    var rating: Double? {
        return object[Fields.Rating] as? Double
    }

    var addressLine: String? {
        return object[Fields.AddressLine1] as? String
    }

    var city: String? {
        return object[Fields.City] as? String
    }

    var state: String? {
        return object[Fields.State] as? String
    }

    var zipcode: String? {
        return object[Fields.Zipcode] as? String
    }

    var pfObject: PFObject {
        return object
    }

    // MARK: - Confirmation to MKAnnotation protocol
    var title: String? {
        return name
    }
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: (seaLocation?.coordinate.latitude)!, longitude: (seaLocation?.coordinate.longitude)!)
    }

    // MARK: - Initializers
    init(activityObject: PFObject) {
        object = activityObject
    }

    // MARK: - Instance methods
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

    // MARK: - Class methods
    class func getActivitiesForObjectIdList(activityObjectList: [String], withCompletion completion: (([Activity]?, NSError?) -> ())) {
        let idListForPredicate = activityObjectList.joinWithSeparator("', '")
        let predicate = NSPredicate(format: "\(Fields.OjbectId) in {'\(idListForPredicate)'}")

        // prepare query
        let userPlanQuery = PFQuery(className: ObjectName, predicate: predicate)
        userPlanQuery.cachePolicy = .NetworkElseCache // @todo: uncomment the line when all the fields have been finalized
        userPlanQuery.orderByDescending(Fields.Rating)

        var planActivities: [Activity]?
        userPlanQuery.findObjectsInBackgroundWithBlock { (activities: [PFObject]?, error: NSError?) -> Void in
            if let activities = activities {
                planActivities = activities.map { Activity(activityObject: $0) }
            } else {
                print(error?.localizedDescription)
            }
            completion(planActivities, error)
        }
    }
}
