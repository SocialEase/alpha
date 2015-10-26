//
//  BusinessDetailViewCell.swift
//  SocialEase
//
//  Created by Mo, Kevin on 10/25/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

class BusinessDetailViewCell: UITableViewCell {

    @IBOutlet weak var businessImageView: UIImageView!
    
    @IBOutlet weak var businessNameLabel: UILabel!
    
    @IBOutlet weak var ratingsImageView: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    
    
    var activity: SEAActivity! {
        didSet {
            updateBusinessDetailsInCell()
        }
    }
    
//    var name: String?
//    var location: String?
//    var rating: Float?
//    var posterImageUrl: NSURL?
    
    func updateBusinessDetailsInCell() {
        businessImageView.contentMode = .ScaleToFill
        businessImageView.setImageWithURL(activity.posterImageUrl!)
        businessNameLabel.text = activity.name
        //categoryLabel.text = activity.categories
        //reviewLabel.text = "\(activity.reviewCount!) Reviews"
        
        //openLabel.text = business.open! ? "Open" : "Closed"
        //openLabel.textColor = activity.open! ? UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1) : UIColor.redColor()
        //distanceLabel.text = activity.distance
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
