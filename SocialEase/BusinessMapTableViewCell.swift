//
//  BusinessMapTableViewCell.swift
//  SocialEase
//
//  Created by Mo, Kevin on 10/25/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class BusinessMapTableViewCell: UITableViewCell {

    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessDetailsLabel: UILabel!
    @IBOutlet weak var businessRatingLabel: UILabel!
    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var businessLocationMapView: MKMapView!

    var activity: Activity! {
        didSet {
            updateCellView()
        }
    }

    let regionRadius: CLLocationDistance = 250

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        businessImageView.clipsToBounds = true
        businessImageView.contentMode = .ScaleAspectFill
        ViewTransformationUtils.convertViewToCircle(businessImageView, borderColor: UIColor.clearColor(), borderWidth: 5)

        // update map view
        businessLocationMapView.layer.cornerRadius = 5
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - Helper Methods
    func updateCellView() {
        businessNameLabel?.text = activity.name
        businessDetailsLabel?.text = activity.details
        businessRatingLabel?.text = AppUtilities.getRatingsTextFromRating(activity.rating!)

        if let posterImageUrl = activity.posterImageUrl {
            businessImageView.setImageWithURLRequest(NSURLRequest(URL: posterImageUrl), placeholderImage: nil, fadeInWithDuration: 0.5)
        }

        centerMapOnLocation(CLLocation(latitude: activity.coordinate.latitude, longitude: activity.coordinate.longitude))
    }

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        businessLocationMapView.setRegion(coordinateRegion, animated: true)
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        businessLocationMapView.addAnnotation(dropPin)
    }
}
