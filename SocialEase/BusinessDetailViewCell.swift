//
//  BusinessDetailViewCell.swift
//  SocialEase
//
//  Created by Mo, Kevin on 10/25/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit
import AFNetworking

class BusinessDetailViewCell: UITableViewCell {

    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!

    var activity: Activity! {
        didSet {
            updateBusinessDetailsInCell()
        }
    }

    func updateBusinessDetailsInCell() {
        businessImageView.contentMode = .ScaleToFill
        if let imageUrl = activity.posterImageUrl {
            businessImageView.setImageWithURL(imageUrl)
        }

        businessNameLabel.text = activity.name
        ratingLabel.text = AppUtilities.getRatingsTextFromRating(activity.rating!)
        categoryLabel.text = activity.details
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
