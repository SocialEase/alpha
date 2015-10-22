//
//  SuggestedPlaceViewCell.swift
//  SocialEaseSuggestionsWorkflow
//
//  Created by Amay Singhal on 10/18/15.
//  Copyright © 2015 ple. All rights reserved.
//

import UIKit
import AFNetworking

class SuggestedPlaceViewCell: UITableViewCell {

    @IBOutlet weak var activityDetailsView: UIView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!

    static let Identifier = "SuggestedPlaceViewCell"
    static let EstimateRowHeight: CGFloat = 180

    
    var activity: SEAActivity! {
        didSet {
            setupUIViewCell()
        }
    }
    var cellSelected: Bool! {
        didSet {
            activityDetailsView?.backgroundColor = cellSelected! ? UIColor(red: 0/255, green: 114/255, blue: 187/255, alpha: 0.9) : UIColor(red: 127/255, green: 127/255, blue: 127/255, alpha: 0.9)
        }

    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func setupUIViewCell() {
        nameLabel.text = activity.name
        locationLabel.text = activity.location
        if let imageUrl = activity.posterImageUrl {
            posterImage.setImageWithURL(imageUrl)
        }
    }
}
