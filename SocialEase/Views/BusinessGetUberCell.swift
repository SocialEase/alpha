//
//  BusinessGetUberCell.swift
//  SocialEase
//
//  Created by Soumya on 11/4/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit
import CoreLocation

class BusinessGetUberCell: UITableViewCell {
    var activityName: String!
    var activityCoordinate: CLLocationCoordinate2D!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func didGetUber(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let deviceLocation = appDelegate.deviceLocation {
            let pickupLocation = CLLocationCoordinate2D(latitude: deviceLocation.coordinate.latitude, longitude: deviceLocation.coordinate.latitude)
            
            // Create an Uber instance
            let uber = Uber(pickupLocation: pickupLocation)
            
            // Set a few optional properties
            uber.dropoffLocation = activityCoordinate
            uber.dropoffNickname = activityName
            
            // Let's do it!
            uber.deepLink()
        }
    }
}
